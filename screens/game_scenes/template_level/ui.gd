extends CanvasLayer

var hints_shown: bool = false


func _ready():
	%HintButton.pressed.connect(self.toggle_hints)
	%HiddenButton.pressed.connect(self.toggle_hints)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("hint"):
		toggle_hints()

func toggle_hints():
	if hints_shown:
		get_tree().paused = false
		$AnimationPlayer.play_backwards("show_hint")
	else:
		get_tree().paused = true
		$AnimationPlayer.play("show_hint")
	hints_shown = !hints_shown
