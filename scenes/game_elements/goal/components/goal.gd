extends Area2D

signal achieved

func _ready() -> void:
	body_entered.connect(on_player_entered)
	await get_tree().process_frame # para esperar a que el level se haya inicializado
	var level = get_tree().get_nodes_in_group("level").front()
	if level:
		achieved.connect(level.win)

func on_player_entered(_body):
	achieved.emit()
