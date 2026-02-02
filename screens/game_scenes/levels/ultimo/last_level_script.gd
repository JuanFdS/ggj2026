extends Node

func _ready() -> void:
	$"../Layer/GameElements".child_entered_tree.connect(func(child):
		await get_tree().create_timer(0.5).timeout
		%MaskCutOut.visible = false
		%Preview.visible = false
		$"../AnimationPlayer".play_backwards("poner_hojas")
		await $"../AnimationPlayer".animation_finished
		get_tree().change_scene_to_file.call_deferred("res://screens/menues/main_menu/main_menu.tscn")
	)
