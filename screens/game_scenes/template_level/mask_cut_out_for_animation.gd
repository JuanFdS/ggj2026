extends Sprite2D

var pos: Vector2

func _ready() -> void:
	visible = false
	%MaskHole.visible = false
	%MaskHole/FondoTexture.texture = %Fondo.texture

func _process(delta: float) -> void:
	offset = %MaskSelection.position - Vector2(%MaskSelection.mask_size) / 2
	region_rect.size = Vector2(%MaskSelection.mask_size)
	%MaskHole.region_rect.size = region_rect.size
	%MaskHole.offset = %MaskSelection.global_position - Vector2(%MaskSelection.mask_size) / 2
	

func play_mask_animation():
	# Seguro hay mejores maneras de encadenar tweens
	$sfx/recorte_hoja.play()
	%MaskHole.visible = true
	visible = true
	var duration_in_seconds: float = 1.0
	create_tween().tween_property(
			self, "global_position", %Preview.global_position, duration_in_seconds
		).from(%MaskSelection.global_position - %MaskSelection.position)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_IN_OUT)

	create_tween().tween_property(
			self, "rotation", -PI / 16, duration_in_seconds / 2.0
		).set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_IN_OUT).finished.connect(func():

			create_tween()\
			.tween_property(self, "rotation", 0.0, duration_in_seconds / 2.0)\
			.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT))

	await create_tween().tween_property(
			self, "scale", Vector2.ONE * 1.2, duration_in_seconds / 2.0
		).set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_IN_OUT).finished
	await create_tween().tween_property(
			self, "scale", Vector2.ONE, duration_in_seconds / 2.0
		).set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_IN_OUT).finished
	visible = false


func play_unmask_animation():
	$sfx/arranco_pedazo.play()
	visible = true
	var duration_in_seconds: float = 0.5
	create_tween().tween_property(
			self, "scale", Vector2.ONE * 1.2, duration_in_seconds / 2.0
		).set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_IN_OUT).finished.connect(func():
		create_tween().tween_property(
			self, "scale", Vector2.ONE, duration_in_seconds / 2.0
		).set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_IN_OUT)
	)
	await create_tween().tween_property(
			self, "global_position", %MaskSelection.global_position - %MaskSelection.position, duration_in_seconds
		).from(%Preview.global_position)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_IN_OUT).finished
	visible = false
	%MaskHole.visible = false
