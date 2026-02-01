extends CharacterBody2D

@onready var sprite_2d: AnimatedSprite2D = $Mask/Sprite2D

var SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer

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
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		sprite_2d.flip_h = direction < 0
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func die(animation_name = &"die"):
	var level = get_tree().get_nodes_in_group("level").front()
	if level.dying:
		return
	SPEED = SPEED / 2
	level.dying = true

	animation_player.play(animation_name)
	await animation_player.animation_finished
	level.lose()
