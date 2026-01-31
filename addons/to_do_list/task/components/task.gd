@tool
extends Control

var text: String :
	get():
		return rich_text_label.text
	set(new_value):
		rich_text_label.text = new_value
		line_edit.text = new_value
@onready var rich_text_label: RichTextLabel = %RichTextLabel
@onready var line_edit: LineEdit = %LineEdit
@onready var check_box: CheckBox = %CheckBox
@onready var drag_button: Button = %DragButton
var editing: bool = true :
	set(new_value):
		editing = new_value
		if not is_node_ready():
			await ready
		drag_button.disabled = editing
		line_edit.visible = editing
		rich_text_label.visible = !editing

signal finished_editing

func _ready() -> void:
	drag_button.disabled = true
	rich_text_label.gui_input.connect(func(event):
		if event is InputEventMouseButton:
			if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
				editing = true
				line_edit.grab_focus()
	)
	line_edit.focus_exited.connect(func():
		task_finished_editing()
	)
	line_edit.text_submitted.connect(func(_new_text):
		task_finished_editing()
	)
	line_edit.text_changed.connect(func(_new_value):
		update_rich_text_label()
	)
	check_box.toggled.connect(func(_new_value):
		update_rich_text_label()
	)

func task_finished_editing():
	if line_edit.text:
		editing = false
		finished_editing.emit()

func update_rich_text_label():
	var text = line_edit.text
	rich_text_label.text = "[s]%s[/s]" % text if check_box.button_pressed else text
	
func try_grab_focus():
	line_edit.grab_focus()

func draw_dragging_target_indicator(dragging_position: Vector2):
	var is_dragging_next: bool = get_global_rect().get_center().y < dragging_position.y
	$HSeparatorPrevious.visible = !is_dragging_next
	$HSeparatorNext.visible = is_dragging_next

func clear_dragging_target_indicator():
	$HSeparatorPrevious.visible = false
	$HSeparatorNext.visible = false

func task_list():
	return get_parent()
