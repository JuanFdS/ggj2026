extends Node2D

func receive_masked_body(body):
	var duplicated_body = body.duplicate()
	add_child(duplicated_body)
	duplicated_body.position = body.position
