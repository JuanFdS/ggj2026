extends Area2D

@onready var kill_zone: Area2D = $KillZone

func _ready() -> void:
	kill_zone.body_entered.connect(func(body):
		body.die(&"burn_to_crisps")
	)
