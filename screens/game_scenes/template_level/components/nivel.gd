@tool
extends Node2D

enum PlayState {
	Playing,
	Won,
	Dying
}

var play_state = PlayState.Playing

func completed() -> bool:
	return play_state in [PlayState.Won, PlayState.Dying]

func player_died():
	play_state = PlayState.Dying

@export var mask_size: Vector2i = Vector2i(200, 100):
	set(new_value):
		mask_size = new_value
		if not is_node_ready():
			await ready
		%PreviewMask.mask_size = mask_size
		%MaskSelection.mask_size = mask_size
		
@export var canvas_size: Vector2i = Vector2i(600, 600):
	set(new_value):
		canvas_size = new_value
		if not is_node_ready():
			await ready
		
		%LayerBackground.scale = Vector2(canvas_size) / %LayerBackground.texture.get_size()
		$Layer/ScenarioBorders/Right.position = canvas_size
		
		%MaskBackground.scale = Vector2(canvas_size) / %MaskBackground.texture.get_size()
		
		%MaskSubviewport.size = canvas_size
		%LayerSubviewport.size = canvas_size


func _ready() -> void:
	%MaskSubviewport.size = %LayerBackground.texture.get_size()
	%LayerSubviewport.size = %MaskBackground.texture.get_size()
	%MaskCamera.offset = %Mask.position
	%LayerCamera.offset = %Layer.position
	if Engine.is_editor_hint():
		return
	add_to_group("level")
	if LevelManager.resetting:
		%Layer.modulate = Color.BLACK
		%Mask.modulate = Color.BLACK
		$AnimationPlayer.play("restaurar_hojas")
	else:
		$Layer/GameElements.visible = false
		%LayerBackground.visible = false
		%Mask.visible = false
		$AnimationPlayer.play("poner_hojas")
		$AnimationPlayer.animation_finished.connect(func(animation_finished):
			get_tree().paused = false
		)
		get_tree().paused = true
	

func win():
	play_state = PlayState.Won
	#%Preview.modulate.a = 0
	#%PreviewMask.modulate.a = 0
	#%LayerPreview.modulate.a = 0
	#%MaskCutOut.modulate.a = 0
	#%MaskCutOutForAnimation.modulate.a = 0

func go_to_next_level():
	%MaskCutOut.visible = false
	$AnimationPlayer.play_backwards("poner_hojas")
	$AnimationPlayer.animation_finished.connect(func(animation_finished):
		get_tree().paused = false
		LevelManager.advance_to_next_level()
	)
	get_tree().paused = true

func _process(delta):
	if Engine.is_editor_hint():
		return
	if Input.is_action_just_pressed("Reset"):
		lose()

func lose():
	$AnimationPlayer.play("sacudir_hojas")
	await $AnimationPlayer.animation_finished
	LevelManager.reset_level()
