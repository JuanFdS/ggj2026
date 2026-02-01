extends Control

@onready var focus_control = $Focus

func _ready():
	focus_control.visible = false

func focus():
	focus_control.visible = true

func unfocus():
	focus_control.visible = false

func aceptar():
	pass
