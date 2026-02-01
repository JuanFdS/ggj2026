@tool
extends Node2D

var dying: bool = false
@export var mask_size: Vector2i = Vector2i(200, 100):
	set(new_value):
		mask_size = new_value
		if not is_node_ready():
			await ready
		%PreviewMask.mask_size = mask_size
		%MaskSelection.mask_size = mask_size
		
@export var canvas_size: Vector2i = Vector2i(600, 600):
	set(new_value):
		canvas_size = new_value
		if not is_node_ready():
			await ready
		
		%LayerBackground.scale = Vector2(canvas_size) / %LayerBackground.texture.get_size()
		$Layer/StaticBody2D/Bottom.position = canvas_size
		$Layer/StaticBody2D/Right.position = canvas_size
		
		%MaskBackground.scale = Vector2(canvas_size) / %MaskBackground.texture.get_size()
		
		%MaskSubviewport.size = canvas_size
		%LayerSubviewport.size = canvas_size


func _ready() -> void:
	%MaskSubviewport.size = %LayerBackground.texture.get_size()
	%LayerSubviewport.size = %MaskBackground.texture.get_size()
	%MaskCamera.offset = %Mask.position
	%LayerCamera.offset = %Layer.position
	if Engine.is_editor_hint():
		return
	add_to_group("level")

func win():
	LevelManager.advance_to_next_level()
	%ganaste.visible = true

func lose():
	pass
