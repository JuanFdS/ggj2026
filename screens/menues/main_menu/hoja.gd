extends TextureRect

@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"

signal closed

func open():
	animation_player.play("mostrar")
	grab_focus()

func close():
	animation_player.play_backwards("mostrar")
	closed.emit()

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
			close()
			accept_event()
	if event.is_action_pressed("ui_accept"):
		close()
		accept_event()
	
