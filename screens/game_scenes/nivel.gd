@tool
extends Node2D

@export var mask_size: Vector2i = Vector2i(200, 100):
	set(new_value):
		mask_size = new_value
		if not is_node_ready():
			await ready
		%PreviewMask.mask_size = mask_size
		%MaskSelection.mask_size = mask_size
@onready var goal: Node2D = %Goal

func _ready() -> void:
	%MaskSubviewport.size = %LayerBackground.texture.get_size()
	%LayerSubviewport.size = %MaskBackground.texture.get_size()
	%MaskCamera.offset = %Mask.position
	%LayerCamera.offset = %Layer.position
	if Engine.is_editor_hint():
		return
	add_to_group("level")

func win():
	%ganaste.visible = true
	get_tree().paused = true
