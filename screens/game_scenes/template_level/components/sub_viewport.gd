extends SubViewport

@export var camera: Camera2D
@export var canvas: Node2D

func _ready() -> void:
	world_2d = get_tree().root.get_viewport().world_2d
	camera.offset = canvas.position
	camera.rotation = canvas.rotation
