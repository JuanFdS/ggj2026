extends CanvasLayer

@onready var sub_viewport: SubViewport = $SubViewportContainer/SubViewport

func _ready() -> void:
	sub_viewport.world_2d = get_viewport().world_2d
