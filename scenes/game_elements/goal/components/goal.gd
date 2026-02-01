extends Area2D

signal achieved

func _ready() -> void:
	body_entered.connect(on_player_entered)

func on_player_entered(_body):
	var level = _level()
	if level.completed():
		return
	level.win()
	create_tween().tween_property(_body, "global_position", $Stairs.global_position, 1.0)\
		.set_trans(Tween.TRANS_QUAD)
	await create_tween().tween_property(_body, "modulate", Color(0,0,0,0), 1.0)\
		.set_trans(Tween.TRANS_QUAD).finished
	level.go_to_next_level()

func _level():
	return get_tree().get_first_node_in_group("level")
