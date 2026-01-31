@tool
extends MarginContainer

func _ready() -> void:
	%GamepadType.configure({
		"Xbox": "xbox",
		"PlayStation": "playstation",
		"Nintendo": "nintendo",
		"Generic": "generic",
	},
	"xbox",
	func(gamepad_type):
		pass)
	
	%ControlScheme.configure({
		"Default": "default",
		"Alternative": "alternative",
		"Southpaw": "southpaw",
		"Custom": "custom",
	},
	"default",
	func(control_scheme):
		pass)
