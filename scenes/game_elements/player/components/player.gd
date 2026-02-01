extends CharacterBody2D

@onready var sprite_2d: AnimatedSprite2D = %Sprite2D

var SPEED = 300.0
const JUMP_VELOCITY = -450.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var COYOTE_TIME: float = 0.15
@onready var coyote_time_left: float = COYOTE_TIME
var last_direction: float

func _physics_process(delta: float) -> void:
	var is_in_layer = GameElementUtils.is_in_layer(self)
	sprite_2d.process_mode = Node.PROCESS_MODE_DISABLED if !is_in_layer else Node.PROCESS_MODE_INHERIT
	if !is_in_layer:
		return
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		coyote_time_left = COYOTE_TIME

	coyote_time_left = move_toward(coyote_time_left, 0.0, delta)
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and (is_on_floor() or coyote_time_left > 0.0):
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		if not is_zero_approx(last_direction) and direction != last_direction:
			flip()
		sprite_2d.flip_h = direction < 0
		velocity.x = direction * SPEED
		last_direction = direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	update_animations()
	
	if not GameElementUtils.is_completed():
		var sprite_pivot = $SpritePivotOuter
		if 0.0 < abs(velocity.y):
			sprite_pivot.scale.x = move_toward(sprite_pivot.scale.x, 0.95, delta)
			sprite_pivot.scale.y = move_toward(sprite_pivot.scale.y, 1.05, delta)
		elif 0.0 < abs(velocity.x):
			sprite_pivot.scale.x = move_toward(sprite_pivot.scale.x, 1.05, delta)
			sprite_pivot.scale.y = move_toward(sprite_pivot.scale.y, 0.95, delta)
		else:
			sprite_pivot.scale.x = move_toward(sprite_pivot.scale.x, 1.0, delta)
			sprite_pivot.scale.y = move_toward(sprite_pivot.scale.y, 1.0, delta)
		sprite_pivot.rotation = rotate_toward(sprite_pivot.rotation, PI / 40 * sign(velocity.x), delta)

func flip():
	if GameElementUtils.is_completed():
		return

func update_animations():
	if GameElementUtils.is_completed():
		return
	if abs(velocity.x) > 0.0:
		sprite_2d.play("default")
	else:
		sprite_2d.stop()

func die(animation_name = &"die"):
	var level = get_tree().get_nodes_in_group("level").front()
	if level.completed():
		return
	SPEED = SPEED / 2
	level.player_died()

	animation_player.play(animation_name)
	await animation_player.animation_finished
	level.lose()
