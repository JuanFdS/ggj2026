extends Node2D

var occluded_bodies: Array[Node] = []
var received_bodies: Array[Node] = []

func apply_mask(bodies):
	for thing: Node in (%PreviewArea.get_overlapping_bodies() + %PreviewArea.get_overlapping_areas()):
		occluded_bodies.push_back(thing)
		thing.process_mode = Node.PROCESS_MODE_DISABLED
		thing.visible = false
	for body in bodies:
		var duplicated_body = body.duplicate()
		add_child(duplicated_body)
		duplicated_body.position = body.position
		received_bodies.push_back(duplicated_body)

func unapply_mask():
	for body: Node in occluded_bodies:
		body.process_mode = Node.PROCESS_MODE_INHERIT
		body.visible = true
	occluded_bodies.clear()
	for body in received_bodies:
		body.queue_free()
	received_bodies.clear()
