extends Node2D

func _physics_process(delta: float) -> void:
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
			player.die("burn_to_crisps")
			
