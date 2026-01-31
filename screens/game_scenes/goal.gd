extends Node2D

@onready var area_2d: Area2D = $Area2D

signal achieved

func _ready() -> void:
	area_2d.body_entered.connect(on_player_entered)

func on_player_entered(_body):
	achieved.emit()
