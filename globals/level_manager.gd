extends Node

@export_file("*.tscn") var levels: Array[String]

var current_level_idx: int = 0
var resetting: bool = false

func _ready() -> void:
	if get_tree().current_scene:
		var file_path = get_tree().current_scene.scene_file_path
		var uid = ResourceUID.path_to_uid(file_path)
		if uid and levels.has(uid):
			current_level_idx = levels.find(uid)

func advance_to_next_level():
	current_level_idx = (current_level_idx + 1) % levels.size()
	go_to_level()

func start_from_first_level():
	current_level_idx = 0
	go_to_level()

func go_to_level():
	$sfx/cambio_hoja.play()
	var level_file_path = levels[current_level_idx]
	get_tree().change_scene_to_file.call_deferred(levels[current_level_idx])

func reset_level():
	resetting = true
	get_tree().reload_current_scene()
	await get_tree().process_frame
	await get_tree().current_scene.ready
	resetting = false
