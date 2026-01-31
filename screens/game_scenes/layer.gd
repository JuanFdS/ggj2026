extends Node2D

var occluded_bodies: Array[Node] = []

func apply_mask(bodies):
	for thing: Node in (%PreviewArea.get_overlapping_bodies() + %PreviewArea.get_overlapping_areas()):
		occluded_bodies.push_back(thing)
		thing.process_mode = Node.PROCESS_MODE_DISABLED
		thing.visible = false
	for body in bodies:
		var duplicated_body = body.duplicate()
		add_child(duplicated_body)
		duplicated_body.position = body.position
		body.queue_free()

func unapply_mask():
	for body: Node in occluded_bodies:
		body.process_mode = Node.PROCESS_MODE_INHERIT
		body.visible = true
	occluded_bodies.clear()

	for thing: Node in (%PreviewArea.get_overlapping_bodies() + %PreviewArea.get_overlapping_areas()):
		var duplicated_thing = thing.duplicate()
		%Mask.add_child(duplicated_thing)
		duplicated_thing.position = thing.position
		thing.queue_free()
