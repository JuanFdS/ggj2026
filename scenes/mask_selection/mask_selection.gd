extends Node2D
@onready var sprite_2d: Sprite2D = $Sprite2D

var dragging: bool = false

func _physics_process(delta: float) -> void:
	var mouse_is_hovering = sprite_2d.get_rect().has_point(sprite_2d.get_local_mouse_position())
	if Input.is_action_just_pressed("dragging_mask") and mouse_is_hovering:
		dragging = true
	if Input.is_action_just_released("dragging_mask"):
		dragging = false
	if dragging:
		global_position = get_global_mouse_position()
