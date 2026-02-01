extends Area2D

@onready var kill_zone: Area2D = $KillZone
@onready var box_detection_area: Area2D = $BoxDetectionArea
@onready var particles: CPUParticles2D = $CPUParticles2D

var boxes = []

func _ready() -> void:
	kill_zone.body_entered.connect(func(body):
		body.die(&"burn_to_crisps")
	)
	box_detection_area.body_entered.connect(func(box):
		boxes.push_back(box)
		toggle_fire(false)
	)
	box_detection_area.body_exited.connect(func(box):
		if not box.is_physics_processing():
			# no quiero hacer esto porque se esta cambiando de modo
			return
		boxes.erase(box)
		if boxes.is_empty():
			toggle_fire(true)
	)

func toggle_fire(is_on: bool):
	kill_zone.set_deferred("monitoring", is_on)
	particles.emitting = is_on
