extends Area2D

signal achieved

func _ready() -> void:
	body_entered.connect(on_player_entered)

func on_player_entered(_body):
	var level = _level()
	if level.dying:
		return
	level.win()

func _level():
	return get_tree().get_first_node_in_group("level")
