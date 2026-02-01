extends Node2D

func is_in_layer() -> bool:
	var parent_node = get_parent()
	while parent_node:
		if parent_node.is_in_group("layer"):
			return true
		parent_node = parent_node.get_parent()
	return false

func _physics_process(delta: float) -> void:
	if !is_in_layer():
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
