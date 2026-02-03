extends Control

var opcion_actual_idx: int = 0
@onready var posiciones: Control = $Posiciones
@onready var pointer: Control = %Pointer

func _ready():
	cambiar_a_opcion(0)
	for opcion in %Posiciones.get_children():
		opcion.mouse_entered.connect(func():
			cambiar_a_opcion(opcion.get_index())
		)
		opcion.pressed.connect(func():
			aceptar_opcion(opcion)
		)
	await get_tree().process_frame
	grab_focus()
	for hoja in [$Credits/Hoja]:
		hoja.closed.connect(func(): self.grab_focus())

func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_down"):
		cambiar_opcion_actual_por(1)
		$sfx/hover.play()
		accept_event()
	if event.is_action_pressed("ui_up"):
		cambiar_opcion_actual_por(-1)
		$sfx/hover.play()
		accept_event()
	if event.is_action_pressed("ui_accept"):
		aceptar_opcion_actual()
		$sfx/click.play()
		accept_event()

func _process(delta: float) -> void:
	var opcion_actual: Control = obtener_opcion(opcion_actual_idx)
	pointer.global_position = pointer.global_position.lerp(
		opcion_actual.global_position + Vector2.RIGHT * opcion_actual.get_rect().size.x,
		1 - pow(0.01, delta)
	)

func aceptar_opcion_actual():
	aceptar_opcion(obtener_opcion(opcion_actual_idx))

func aceptar_opcion(opcion):
	match opcion.name:
		"Jugar":
			LevelManager.start_from_first_level()
		"ElegirNivel":
			$SelectLevel/Hoja.open()
		"Configuracion":
			$Settings/Hoja.open()
		"Creditos":
			$Credits/Hoja.open()
		"Salir":
			get_tree().quit()

func obtener_opcion(idx):
	return $Posiciones.get_child(opcion_actual_idx)

func cambiar_a_opcion(nueva_opcion_idx):
	obtener_opcion(opcion_actual_idx).unfocus()
	opcion_actual_idx = nueva_opcion_idx
	obtener_opcion(opcion_actual_idx).focus()

func cambiar_opcion_actual_por(delta):
	cambiar_a_opcion((opcion_actual_idx + delta) % $Posiciones.get_child_count())

	
