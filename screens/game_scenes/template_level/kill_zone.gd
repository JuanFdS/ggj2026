extends Area2D

func _ready():
	body_entered.connect(func(body): body.die(&"fall"))
