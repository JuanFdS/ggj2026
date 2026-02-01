@tool
extends Control

func _ready():
	%GoToLayer.pressed.connect(on_go_to_layer)
	%GoToMask.pressed.connect(on_go_to_mask)
	%AddPlatform.pressed.connect(on_add_platform)
	%AddFire.pressed.connect(on_add_fire)
	%AddBox.pressed.connect(on_add_box)
	%AddPlayer.pressed.connect(on_add_player)
	%AddGoal.pressed.connect(on_add_goal)
	%NoLevelOpenMessage.visible = false
	%Buttons.visible = false
	EditorInterface.get_selection().selection_changed.connect(on_new_selection)
	
func on_new_selection():
	if not get_tree().edited_scene_root:
		return
	if not get_tree().edited_scene_root.is_in_group("level"):
		return
	var in_any_game_elements: bool = !!current_game_elements()
	for button in [%AddPlatform, %AddFire, %AddBox, %AddPlayer, %AddGoal]:
		button.disabled = not in_any_game_elements

func current_game_elements():
	var selected_nodes = EditorInterface.get_selection().get_selected_nodes()
	
	var layer_game_elements = get_tree().edited_scene_root.get_node("Layer/GameElements")
	if selected_nodes.size() > 0 and selected_nodes.all(func(node):
		return layer_game_elements == node or layer_game_elements.is_ancestor_of(node)
	):
		return layer_game_elements
	var mask_game_elements = get_tree().edited_scene_root.get_node("Mask/GameElements")
	if selected_nodes.size() > 0 and selected_nodes.all(func(node):
		return mask_game_elements == node or mask_game_elements.is_ancestor_of(node)
	):
		return mask_game_elements
	return null

func scene_changed(new_scene):
	if not new_scene:
		return
	%NoLevelOpenMessage.visible = not new_scene.is_in_group("level")
	%Buttons.visible = new_scene.is_in_group("level")

func on_go_to_layer():
	if not get_tree().edited_scene_root.is_in_group("level"):
		return
	var game_elements = get_tree().edited_scene_root.get_node("Layer/GameElements")
	EditorInterface.get_selection().clear()
	EditorInterface.edit_node(game_elements)

func on_go_to_mask():
	var game_elements = get_tree().edited_scene_root.get_node("Mask/GameElements")
	EditorInterface.get_selection().clear()
	EditorInterface.edit_node(game_elements)

func on_add_scene(scene):
	var instance = scene.instantiate()
	current_game_elements().add_child(instance, true)
	instance.owner = get_tree().edited_scene_root
	await get_tree().process_frame
	EditorInterface.get_selection().clear()
	EditorInterface.edit_node(instance)

func on_add_platform():
	on_add_scene(preload("res://scenes/game_elements/platforms/platform_1.tscn"))
	
func on_add_fire():
	on_add_scene(preload("res://scenes/game_elements/fire/MultipleFire.tscn"))

func on_add_box():
	on_add_scene(preload("res://scenes/game_elements/box/box.tscn"))

func on_add_player():
	on_add_scene(preload("res://scenes/game_elements/player/player.tscn"))

func on_add_goal():
	on_add_scene(preload("res://scenes/game_elements/goal/goal.tscn"))
