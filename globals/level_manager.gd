extends Node

@export_file("*.tscn") var levels: Array[String]

var current_level_idx: int = 0

func _ready() -> void:
	if get_tree().current_scene:
		var file_path = get_tree().current_scene.scene_file_path
		var uid = ResourceUID.path_to_uid(file_path)
		if uid and levels.has(uid):
			current_level_idx = levels.find(uid)

func advance_to_next_level():
	current_level_idx = (current_level_idx + 1) % levels.size()
	var next_level_path = levels[current_level_idx]
	get_tree().change_scene_to_file.call_deferred(next_level_path)
