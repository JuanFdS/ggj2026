extends Area2D

signal achieved

func _ready() -> void:
	body_entered.connect(on_player_entered)

func on_player_entered(_body):
	achieved.emit()
