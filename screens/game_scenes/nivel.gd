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
	if Engine.is_editor_hint():
		return
	goal.achieved.connect(func():
		%ganaste.visible = true
		get_tree().paused = true
	)
