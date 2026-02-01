extends Node2D

@onready var mask_button: Button = %MaskButton
@onready var mask_selection: Node2D = %MaskSelection
@onready var layer: Node2D = %Layer

enum State {
	Playing,
	Masking
}

var state = State.Playing
@onready var preview: Sprite2D = %Preview
@onready var layer_preview: Sprite2D = %LayerPreview

func _ready() -> void:
	_change_state(State.Masking)
	mask_button.pressed.connect(toggle_mask)
	rotation_degrees = 1

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("toggle_mask"):
		toggle_mask()
	%LayerPreviewMask.position = %MaskSelection.position

func toggle_mask():
	if get_tree().get_first_node_in_group("level").dying:
		return
	match state:
		State.Playing:
			%Layer.unapply_mask()
			_change_state(State.Masking)
		State.Masking:
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
			self.modulate = Color(0.5,0.5,0.5)
			mask_button.text = "Editar Máscara"
			preview.visible = false
			layer_preview.visible = true
			%MaskSelection.process_mode = Node.PROCESS_MODE_DISABLED
			%Layer.process_mode = Node.PROCESS_MODE_INHERIT
		State.Masking:
			%MaskCutOut.visible = false
			layer.modulate = Color(0.5,0.5,0.5)
			self.modulate = Color.WHITE
			mask_button.text = "Aplicar Máscara"
			preview.visible = true
			layer_preview.visible = false
			%MaskSelection.process_mode = Node.PROCESS_MODE_INHERIT
			%Layer.process_mode = Node.PROCESS_MODE_DISABLED
