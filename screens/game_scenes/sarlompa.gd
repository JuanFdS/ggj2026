extends Sprite2D

func _process(_delta: float) -> void:
	offset = %MaskSelection.position - Vector2(%MaskSelection.mask_size) / 2
	region_rect.size = Vector2(%MaskSelection.mask_size)
