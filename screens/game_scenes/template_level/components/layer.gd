extends Node2D

func _ready() -> void:
	rotation_degrees = -1

var occluded_bodies: Array[Node] = []

func apply_mask(bodies_with_intersections):
	for thing: Node in (%PreviewArea.get_overlapping_bodies() + %PreviewArea.get_overlapping_areas()):
		var intersection_result: IntersectionResult = cut_into_shapes(%PreviewArea, thing)
		for intersection in intersection_result.polygon_intersections:
			var occluded_thing = intersected_body(thing, intersection)
			occluded_bodies.push_back(occluded_thing)
			occluded_thing.position = thing.position
			occluded_thing.process_mode = Node.PROCESS_MODE_DISABLED
			occluded_thing.visible = false
			$GameElements.add_child(occluded_thing, true)
		for intersection in intersection_result.polygon_complements:
			var leftover_piece = intersected_body(thing, intersection)
			$GameElements.add_child(leftover_piece, true)
			leftover_piece.position = thing.position
		thing.queue_free()
			
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
	var collision_polygon_2d: CollisionPolygon2D = new_body.find_children("", "CollisionPolygon2D", true, false).front()
	collision_polygon_2d.polygon = polygon

	return new_body

func translate_polygon(polygon: PackedVector2Array, delta_position: Vector2) -> PackedVector2Array:
	var new_polygon := PackedVector2Array()
	for point in polygon:
		new_polygon.push_back(point + delta_position)
	return new_polygon

func cut_into_shapes(mask_area: Area2D, thing: Node2D) -> IntersectionResult:
	var thing_collision_shape: CollisionPolygon2D = thing.find_children("", "CollisionPolygon2D", false, false).front()
	var mask_shape: Shape2D = mask_area.find_children("", "CollisionShape2D", false, false).front().shape
	var mask_rect := mask_shape.get_rect()
	mask_rect.position += mask_area.global_position
	
	var thing_polygon: PackedVector2Array = translate_polygon(
		thing_collision_shape.polygon,
		thing_collision_shape.global_position
	)
	var mask_polygon: PackedVector2Array = rect_to_polygon(mask_rect)
	
	var base_intersection_polygons := Geometry2D.intersect_polygons(thing_polygon, mask_polygon)
	var base_exclusion_polygons := Geometry2D.clip_polygons(thing_polygon, mask_polygon)
	var intersection_polygons := []
	var exclusion_polygons := []
	for base_polygon in base_intersection_polygons:
		intersection_polygons.push_back(
			translate_polygon(base_polygon, -thing_collision_shape.global_position)
		)
	for base_polygon in base_exclusion_polygons:
		exclusion_polygons.push_back(
			translate_polygon(base_polygon, -thing_collision_shape.global_position)
		)

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
	for thing: Node in (%PreviewArea.get_overlapping_bodies() + %PreviewArea.get_overlapping_areas()):
		if occluded_bodies.has(thing):
			pass

		var intersection_result: IntersectionResult = cut_into_shapes(%PreviewArea, thing)
		for intersection in intersection_result.polygon_intersections:
			var new_thing = intersected_body(thing, intersection)
			%Mask/GameElements.add_child(new_thing, true)
			new_thing.position = thing.position
		for intersection in intersection_result.polygon_complements:
			var new_thing = intersected_body(thing, intersection)
			$GameElements.add_child(new_thing, true)
			new_thing.position = thing.position
		
		thing.queue_free()

	var just_occluded_bodies = occluded_bodies.duplicate()
	for body: Node in occluded_bodies:
		body.process_mode = Node.PROCESS_MODE_INHERIT
		body.visible = true
	occluded_bodies.clear()
