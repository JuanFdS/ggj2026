@tool
extends "res://screens/menues/settings/setting_option.gd"

func _ready() -> void:
	super()
	configure({
		"window_mode_exclusive_fullscreen": Window.MODE_EXCLUSIVE_FULLSCREEN,
		"window_mode_fullscreen": Window.MODE_FULLSCREEN,
		"window_mode_maximized": Window.MODE_MAXIMIZED,
		"window_mode_minimized": Window.MODE_WINDOWED,
	}, Window.MODE_WINDOWED,
	func(windows_mode): get_window().mode = windows_mode)
