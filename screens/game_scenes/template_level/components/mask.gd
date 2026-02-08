extends Node2D

@onready var mask_button: Button = %MaskButton
@onready var mask_selection: Node2D = %MaskSelection
@onready var layer: Node2D = %Layer

enum State {
	Playing,
	Masking
}

var is_splitting_player_with_mask: bool = false
var state = State.Playing
var can_toggle_mask = true
@onready var preview: Sprite2D = %Preview
@onready var layer_preview: Sprite2D = %LayerPreview

func _ready() -> void:
	_change_state(State.Masking)
	mask_button.pressed.connect(toggle_mask)
	# Descomentar solo si arreglamos que la comparacion entre mascara y colision de objetos
	# se haga NO usando su global position, si no una posicion relativa a algun nodo padre.
	# Ya que al usar global position hay rotacion y eso hace muuucho mas facil que se generen
	# cortes con errores.
	#rotation_degrees = 1

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("toggle_mask"):
		toggle_mask()
	%LayerPreviewMask.position = %MaskSelection.position
	if GameElementUtils.is_completed():
		for coso in [%MaskSelection, %Preview]:
			coso.modulate = lerp(coso.modulate, Color.TRANSPARENT, 1 - pow(0.05, delta))
	else:
		var color_forbidden := Color(1.0, 0.553, 0.489, 1.0)
		%MaskSelection.modulate = color_forbidden if is_splitting_player_with_mask else Color.WHITE
		%Preview.modulate = color_forbidden if is_splitting_player_with_mask else Color(0.8,0.8,0.8,0.9)
		%MaskCutOut.modulate = color_forbidden if is_splitting_player_with_mask else Color.WHITE

func would_split_player_in_half() -> bool:
	var player = get_tree().get_first_node_in_group("player")
	if not player:
		return false
	var preview_area_player_intersection = %Layer.cut_into_shapes(%PreviewArea, player)
	var mask_area_player_intersection = %Layer.cut_into_shapes(%MaskSelectionArea, player)
	return (not preview_area_player_intersection.polygon_intersections.is_empty() and not preview_area_player_intersection.polygon_complements.is_empty()) or (
		not mask_area_player_intersection.polygon_intersections.is_empty() and not mask_area_player_intersection.polygon_complements.is_empty()
	)

func _physics_process(delta: float) -> void:
	if get_tree().get_first_node_in_group("level").completed():
		return
	is_splitting_player_with_mask = would_split_player_in_half()

func toggle_mask():
	if get_tree().get_first_node_in_group("level").completed():
		return
	if would_split_player_in_half():
		return
	if not can_toggle_mask:
		return

	can_toggle_mask = false
		
	%sfx/pegado_hoja.play()
	match state:
		State.Playing:
			# Estaría bueno mover esto a otro lado...
			var original_texture = $"../MaskCutOutForAnimation/MaskBackground".texture
			var screenshot = %MaskSubviewport.get_texture().get_image()
			$"../MaskCutOutForAnimation/MaskBackground".texture = ImageTexture.create_from_image(screenshot)
			
			%Layer.unapply_mask()
			%MaskCutOut.visible = false
			get_tree().paused = true
			await %MaskCutOutForAnimation.play_unmask_animation()
			_change_state(State.Masking)
			get_tree().paused = false

			$"../MaskCutOutForAnimation/MaskBackground".texture = original_texture
		State.Masking:
			get_tree().paused = true
			preview.create_tween()\
				.tween_property(preview, "self_modulate:a", 0, 0.3).from(1)
			await %MaskCutOutForAnimation.play_mask_animation()
			var things_with_intersections = {}
			var masked_things = %MaskSelectionArea.get_overlapping_bodies() + %MaskSelectionArea.get_overlapping_areas()
			for thing in masked_things:
				things_with_intersections[thing] = %Layer.cut_into_shapes(%MaskSelectionArea, thing)
			_change_state(State.Playing)
			get_tree().paused = false

			await get_tree().physics_frame
			await get_tree().physics_frame
			%Layer.apply_mask(things_with_intersections)
			%MaskCutOutForAnimation.visible = false
			
	can_toggle_mask = true



func _change_state(new_state):
	state = new_state
	_enter_state(new_state)

func _enter_state(new_state):
	match new_state:
		State.Playing:
			%MaskCutOut.update_size_and_offset()
			%MaskCutOut.visible = true
			# Esto quedó duplicado en mask_cut_out_for_animation
			# (se lo necesita aquí para que el estado inicial esté bien)
			layer.modulate = Color.WHITE
			self.modulate = Color(0.8,0.8,0.8)
			mask_button.text = "Editar Máscara"
			preview.visible = false
			layer_preview.visible = true
			%MaskSelection.process_mode = Node.PROCESS_MODE_DISABLED
			%Layer.process_mode = Node.PROCESS_MODE_INHERIT
		State.Masking:
			%MaskCutOut.visible = false
			layer.modulate = Color(0.8,0.8,0.8)
			self.modulate = Color.WHITE
			mask_button.text = "Aplicar Máscara"
			preview.self_modulate.a = 0
			preview.visible = true
			layer_preview.visible = false
			%MaskSelection.process_mode = Node.PROCESS_MODE_INHERIT
			%Layer.process_mode = Node.PROCESS_MODE_DISABLED
			await create_tween().tween_property(preview, "self_modulate:a", 1, 0.5).from(0)\
				.set_trans(Tween.TRANS_QUAD)\
				.set_ease(Tween.EASE_IN_OUT).finished
