@tool
extends MarginContainer

func _ready() -> void:
	%MasterVolume.configure({
		"0%": 0.0,
		"25%": 0.25,
		"50%": 0.5,
		"75%": 0.75,
		"100%": 1.0,
	},
	1.0,
	func(volume):
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(volume)))
	
	%MusicVolume.configure({
		"0%": 0.0,
		"25%": 0.25,
		"50%": 0.5,
		"75%": 0.75,
		"100%": 1.0,
	},
	1.0,
	func(volume):
		var bus_idx = AudioServer.get_bus_index("Music")
		if bus_idx != -1:
			AudioServer.set_bus_volume_db(bus_idx, linear_to_db(volume)))
	
	%SFXVolume.configure({
		"0%": 0.0,
		"25%": 0.25,
		"50%": 0.5,
		"75%": 0.75,
		"100%": 1.0,
	},
	1.0,
	func(volume):
		var bus_idx = AudioServer.get_bus_index("SFX")
		if bus_idx != -1:
			AudioServer.set_bus_volume_db(bus_idx, linear_to_db(volume)))
