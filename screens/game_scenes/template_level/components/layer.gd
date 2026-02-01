extends Node2D

var occluded_bodies: Array[Node] = []

func apply_mask(bodies_with_intersections):
	for thing: Node in (%PreviewArea.get_overlapping_bodies() + %PreviewArea.get_overlapping_areas()):
		occluded_bodies.push_back(thing)
		thing.process_mode = Node.PROCESS_MODE_DISABLED
		thing.visible = false
	for body in bodies_with_intersections:
		var intersection_result: IntersectionResult = bodies_with_intersections[body]
		for intersection in intersection_result.polygon_intersections:
			var new_body = intersected_body(body, intersection)
			$GameElements.add_child(new_body)
			new_body.position = body.position
		for intersection in intersection_result.polygon_complements:
			var new_body = intersected_body(body, intersection)
			%Mask/GameElements.add_child(new_body)
			new_body.position = body.position
		body.queue_free()

func intersected_body(body: Node2D, polygon: PackedVector2Array) -> Node2D:
	var new_body = body.duplicate()
	var mask: Polygon2D = new_body.get_node("Mask")
	mask.polygon = polygon
	var collision_shape: CollisionShape2D = new_body.find_children("", "CollisionShape2D", true, false).front()
	var new_shape := ConvexPolygonShape2D.new()
	collision_shape.shape = new_shape
	new_shape.points = polygon

	return new_body

func cut_into_shapes(mask_area: Area2D, thing: Node2D) -> IntersectionResult:
	var thing_collision_shape: CollisionShape2D = thing.find_children("", "CollisionShape2D", false, false).front()
	var thing_shape: Shape2D = thing_collision_shape.shape
	var mask_shape: Shape2D = mask_area.find_children("", "CollisionShape2D", false, false).front().shape
	var thing_rect := thing_shape.get_rect()
	thing_rect.position += thing_collision_shape.global_position
	var mask_rect := mask_shape.get_rect()
	mask_rect.position += mask_area.global_position
	
	var thing_polygon: PackedVector2Array = rect_to_polygon(thing_rect)
	var mask_polygon: PackedVector2Array = rect_to_polygon(mask_rect)
	
	var base_intersection_polygons := Geometry2D.intersect_polygons(thing_polygon, mask_polygon)
	var base_exclusion_polygons := Geometry2D.clip_polygons(thing_polygon, mask_polygon)
	var intersection_polygons := []
	var exclusion_polygons := []
	for base_polygon in base_intersection_polygons:
		var new_polygon = PackedVector2Array()
		for point in base_polygon:
			var new_point = point - thing_collision_shape.global_position
			new_polygon.push_back(new_point)
		intersection_polygons.push_back(new_polygon)
	for base_polygon in base_exclusion_polygons:
		var new_polygon = PackedVector2Array()
		for point in base_polygon:
			var new_point = point - thing_collision_shape.global_position
			new_polygon.push_back(new_point)
		exclusion_polygons.push_back(new_polygon)

	var intersection_result = IntersectionResult.new()
	intersection_result.polygon_intersections = intersection_polygons
	intersection_result.polygon_complements = exclusion_polygons
	return intersection_result

func rect_to_polygon(rect: Rect2) -> PackedVector2Array:
	return PackedVector2Array([
		rect.position,
		rect.position + Vector2.RIGHT * rect.size.x,
		rect.end,
		rect.end + Vector2.LEFT * rect.size.x
	])

class IntersectionResult:
	var polygon_intersections: Array
	var polygon_complements: Array

func unapply_mask():
	for body: Node in occluded_bodies:
		body.process_mode = Node.PROCESS_MODE_INHERIT
		body.visible = true
	occluded_bodies.clear()

	for thing: Node in (%PreviewArea.get_overlapping_bodies() + %PreviewArea.get_overlapping_areas()):
		var duplicated_thing = thing.duplicate()
		%Mask/GameElements.add_child(duplicated_thing)
		duplicated_thing.position = thing.position
		thing.queue_free()
