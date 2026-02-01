@tool
extends EditorPlugin

const LEVEL_MAKER_HELPER = preload("uid://cc2d1sdbnbglq")

var dock
var level_maker_helper

func _enter_tree() -> void:
	dock = EditorDock.new()
	level_maker_helper = LEVEL_MAKER_HELPER.instantiate()
	dock.add_child(level_maker_helper)
	dock.title = "Level Maker Helper"
	dock.default_slot = EditorDock.DOCK_SLOT_RIGHT_BL
	add_dock(dock)
	scene_changed.connect(on_scene_changed)


func _exit_tree() -> void:
	remove_dock(dock)
	dock.queue_free()
	dock = null
	scene_changed.disconnect(on_scene_changed)

func on_scene_changed(new_scene):
	if level_maker_helper:
		level_maker_helper.scene_changed(new_scene)
