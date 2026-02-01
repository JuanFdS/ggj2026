extends Sprite2D

func _ready() -> void:
	$MaskBackground.texture = %MaskBackground.texture

func _process(_delta: float) -> void:
	update_size_and_offset()

func update_size_and_offset():
	offset = %MaskSelection.position - Vector2(%MaskSelection.mask_size) / 2
	region_rect.size = Vector2(%MaskSelection.mask_size)
	
