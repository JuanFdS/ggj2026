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

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("toggle_mask"):
		toggle_mask()
	%LayerPreviewMask.position = %MaskSelection.position
	%MaskSelection.modulate = Color.RED if is_splitting_player_with_mask else Color.WHITE
	%Preview.modulate = Color.RED if is_splitting_player_with_mask else Color(0.8,0.8,0.8,0.9)
	%MaskCutOut.modulate = Color.RED if is_splitting_player_with_mask else Color.WHITE

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
	if get_tree().get_first_node_in_group("level").dying:
		return
	is_splitting_player_with_mask = would_split_player_in_half()

func toggle_mask():
	if get_tree().get_first_node_in_group("level").dying:
		return
	if would_split_player_in_half():
		return
	
	%sfx/recorte_hoja.play()
	match state:
		State.Playing:
			get_tree().paused = true
			await %MaskCutOutForAnimation.play_unmask_animation()
			get_tree().paused = false
			%Layer.unapply_mask()
			_change_state(State.Masking)
		State.Masking:
			get_tree().paused = true
			await %MaskCutOutForAnimation.play_mask_animation()
			get_tree().paused = false
			var things_with_intersections = {}
			var masked_things = %MaskSelectionArea.get_overlapping_bodies() + %MaskSelectionArea.get_overlapping_areas()
			for thing in masked_things:
				things_with_intersections[thing] = %Layer.cut_into_shapes(%MaskSelectionArea, thing)
			_change_state(State.Playing)
			await get_tree().physics_frame
			await get_tree().physics_frame
			%Layer.apply_mask(things_with_intersections)


func _change_state(new_state):
	state = new_state
	_enter_state(new_state)

func _enter_state(new_state):
	match new_state:
		State.Playing:
			%MaskCutOut.visible = true
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
			preview.visible = true
			layer_preview.visible = false
			%MaskSelection.process_mode = Node.PROCESS_MODE_INHERIT
			%Layer.process_mode = Node.PROCESS_MODE_DISABLED
