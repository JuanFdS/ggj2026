extends Node2D

@onready var cooldown_to_process: float = 0.1
var time_until_process = 0.0

func _ready():
	time_until_process = cooldown_to_process

func _box_can_process():
	return get_parent().can_process()


func _physics_process(delta: float) -> void:
	if !GameElementUtils.is_in_layer(self):
		return
	if !_box_can_process():
		time_until_process = cooldown_to_process
	time_until_process = move_toward(time_until_process, 0.0, delta)
	if time_until_process > 0.0:
		return

	var box: CharacterBody2D = get_parent()
	if not box.is_on_floor():
		box.velocity += box.get_gravity() * delta
	else:
		box.velocity = Vector2.ZERO

	box.move_and_slide()
	
	var collision = box.get_last_slide_collision()
	if collision and collision.get_collider().is_in_group("player"):
		var player = collision.get_collider()
		if not box.get_real_velocity().is_zero_approx() and box.global_position.y < player.global_position.y:
			player.die("crushed")
