@tool
extends EditorPlugin

const TO_DO_LIST = preload("res://addons/to_do_list/to_do_list.tscn")


var dock: EditorDock

func _enter_tree():
	dock = EditorDock.new()
	dock.title = "ToDo List"
	dock.default_slot = EditorDock.DOCK_SLOT_RIGHT_BL
	var dock_content = TO_DO_LIST.instantiate()
	dock.add_child(dock_content)
	add_dock(dock)

func _exit_tree():
	remove_dock(dock)
	dock.queue_free()
	dock = null
