extends Node2D

@onready var goal: Node2D = %Goal

func _ready() -> void:
	goal.achieved.connect(func():
		%ganaste.visible = true
		get_tree().paused = true
	)
