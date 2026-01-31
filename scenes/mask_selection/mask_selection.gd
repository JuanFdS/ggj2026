@tool
extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@export var mask_size: Vector2i = Vector2i(200, 100) :
	set(new_value):
		mask_size = new_value
		if not is_node_ready():
			await ready
		$Sprite2D.texture.width = mask_size.x
		$Sprite2D.texture.height = mask_size.y
		$MaskSelectionArea/CollisionShape2D.shape.size = mask_size

var dragging: bool = false

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	var mouse_is_hovering = sprite_2d.get_rect().has_point(sprite_2d.get_local_mouse_position())
	if Input.is_action_just_pressed("dragging_mask") and mouse_is_hovering:
		dragging = true
	if Input.is_action_just_released("dragging_mask"):
		dragging = false
	if dragging:
		global_position = get_global_mouse_position()
