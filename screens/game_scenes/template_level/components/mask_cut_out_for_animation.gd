extends Sprite2D

var pos: Vector2

func _ready() -> void:
	visible = false
	%FondoTexture.visible = false
	%FondoTexture.texture = %Fondo.texture

func _process(delta: float) -> void:
	offset = %MaskSelection.position - Vector2(%MaskSelection.mask_size) / 2
	region_rect.size = Vector2(%MaskSelection.mask_size)
	%MaskHole.texture.width = region_rect.size.x
	%MaskHole.texture.height = region_rect.size.y
	%MaskHole.global_position = %MaskSelection.global_position
	

func play_mask_animation():
	# Seguro hay mejores maneras de encadenar tweens
	$sfx/recorte_hoja.play()
	%FondoTexture.visible = true
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
	
	#create_tween().tween_property(%Layer, "modulate", Color.WHITE, duration_in_seconds)
	create_tween().tween_property(%Mask, "modulate", Color(0.8,0.8,0.8), duration_in_seconds)

	await create_tween().tween_property(
			self, "scale", Vector2.ONE * 1.2, duration_in_seconds / 2.0
		).set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_IN_OUT).finished
	await create_tween().tween_property(
			self, "scale", Vector2.ONE, duration_in_seconds / 2.0
		).set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_IN_OUT).finished
	# Lo estamos ocultando en mask.gd
	#visible = false


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
	
	create_tween().tween_property(%Layer, "modulate", Color(0.8,0.8,0.8), duration_in_seconds)
	#create_tween().tween_property(%Mask, "modulate", Color.WHITE, duration_in_seconds)
	
	await create_tween().tween_property(
			self, "global_position", %MaskSelection.global_position - %MaskSelection.position, duration_in_seconds
		).from(%Preview.global_position)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_IN_OUT).finished
	visible = false
	%FondoTexture.visible = false
