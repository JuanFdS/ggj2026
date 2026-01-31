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

func _ready() -> void:
	_change_state(State.Playing)
	mask_button.pressed.connect(toggle_mask)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("toggle_mask"):
		toggle_mask()

func toggle_mask():
	match state:
		State.Playing:
			_change_state(State.Masking)
		State.Masking:
			var masked_bodies = %MaskSelectionArea.get_overlapping_bodies()
			for body in masked_bodies:
				%Layer.receive_masked_body(body)
			_change_state(State.Playing)

func _change_state(new_state):
	state = new_state
	_enter_state(new_state)

func _enter_state(state):
	match state:
		State.Playing:
			layer.modulate = Color.WHITE
			self.modulate = Color(0.5,0.5,0.5)
			mask_button.text = "Editar Máscara"
			preview.visible = false
			%MaskSelection.process_mode = Node.PROCESS_MODE_DISABLED
			%Layer.process_mode = Node.PROCESS_MODE_INHERIT
		State.Masking:
			layer.modulate = Color(0.5,0.5,0.5)
			self.modulate = Color.WHITE
			mask_button.text = "Aplicar Máscara"
			preview.visible = true
			%MaskSelection.process_mode = Node.PROCESS_MODE_INHERIT
			%Layer.process_mode = Node.PROCESS_MODE_DISABLED
