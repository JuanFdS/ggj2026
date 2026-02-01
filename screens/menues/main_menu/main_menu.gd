extends Control

var opcion_actual_idx: int = 0
@onready var posiciones: Control = $Posiciones
@onready var pointer: Control = %Pointer

func _ready():
	cambiar_opcion_actual(0)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_down"):
		cambiar_opcion_actual(1)
	if Input.is_action_just_pressed("ui_up"):
		cambiar_opcion_actual(-1)
	if Input.is_action_just_pressed("ui_accept"):
		aceptar_opcion_actual()
	pointer.global_position = pointer.global_position.lerp(
		obtener_opcion(opcion_actual_idx).global_position,
		1 - pow(0.01, delta)
	)

func aceptar_opcion_actual():
	match obtener_opcion(opcion_actual_idx).name:
		"Jugar":
			LevelManager.start_from_first_level()
		"ElegirNivel":
			pass
		"Configuracion":
			pass
		"Creditos":
			pass
		"Salir":
			get_tree().quit()
	

func obtener_opcion(idx):
	return $Posiciones.get_child(opcion_actual_idx)

func cambiar_opcion_actual(delta):
	obtener_opcion(opcion_actual_idx).unfocus()
	opcion_actual_idx = (opcion_actual_idx + delta) % posiciones.get_children().size()
	obtener_opcion(opcion_actual_idx).focus()
	
