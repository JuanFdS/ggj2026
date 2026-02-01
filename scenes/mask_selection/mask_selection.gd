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
		%LayerPreviewMask.texture.width = mask_size.x
		%LayerPreviewMask.texture.height = mask_size.y
		
@export var MOVE_SPEED: float = 350.0

var last_dragging_position: Vector2 = Vector2.INF

func start_dragging():
	last_dragging_position = get_global_mouse_position()

func process_drag() -> Vector2:
	var mouse_position = get_global_mouse_position()
	var delta = mouse_position - last_dragging_position
	last_dragging_position = mouse_position
	return delta

func stop_dragging():
	last_dragging_position = Vector2.INF

func is_dragging() -> bool:
	return last_dragging_position != Vector2.INF

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	var mouse_is_hovering = sprite_2d.get_rect().has_point(sprite_2d.get_local_mouse_position())
	if Input.is_action_just_pressed("dragging_mask") and mouse_is_hovering:
		start_dragging()
	if Input.is_action_just_released("dragging_mask"):
		stop_dragging()
	global_position += Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") * delta * MOVE_SPEED
	if is_dragging():
		global_position = global_position + process_drag()
