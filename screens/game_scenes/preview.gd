@tool
extends PointLight2D

@export var mask_size: Vector2i = Vector2i(200, 100)

func _ready() -> void:
	texture.width = mask_size.x
	texture.height = mask_size.y

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	position = %MaskSelection.position
