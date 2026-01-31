@tool
extends VBoxContainer

const TASK = preload("uid://ccbv63ee78ofq")
const Task = preload("uid://27jy1dvchw51")
const TaskDragPreview = preload("uid://cfsvfcxa7v20u")

var dragging_position
var dragging_task_target: Task = null
var config_file_path: String = "res://todo_list.txt"

func _ready() -> void:
	var file = FileAccess.open(config_file_path, FileAccess.READ)
	var task_texts = file.get_as_text().split("\n")
	for task_text in task_texts:
		if not task_text.is_empty():
			var new_task = add_task()
			new_task.text = task_text
	for task in get_children():
		task.finished_editing.connect(self.on_task_finished_editing.bind(task))

func add_task():
	var task = TASK.instantiate()
	add_child(task)
	task.owner = owner
	task.finished_editing.connect(self.on_task_finished_editing.bind(task))
	task.try_grab_focus()
	return task

func on_task_finished_editing(task):
	var task_text: String = ""
	var file = FileAccess.open("res://todo_list.txt", FileAccess.READ_WRITE)
	for a_task in _tasks():
		if not a_task.text.is_empty():
			task_text += a_task.text
			task_text += "\n"
	file.store_string(task_text)
	
	var is_last_task = task.get_index() == (get_child_count() - 1)
	if is_last_task:
		add_task()

func _tasks() -> Array:
	return get_children().filter(func(task: Task): return task.is_visible_in_tree() and not task.editing)

func _process(delta: float) -> void:
	if dragging_position:
		var previous_tasks = []
		for task: Task in _tasks():
			if task.get_global_rect().position.y < dragging_position.y:
				previous_tasks.push_back(task)
		if not previous_tasks.is_empty():
			var previous_task: Task = previous_tasks.back()
			if dragging_task_target and dragging_task_target != previous_task:
				dragging_task_target.clear_dragging_target_indicator()
			dragging_task_target = previous_task
			previous_task.draw_dragging_target_indicator(dragging_position)
	elif dragging_task_target:
		dragging_task_target.clear_dragging_target_indicator()
		dragging_task_target = null

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data is Task

func _drop_data(at_position: Vector2, data: Variant) -> void:
	var task_to_move: Task = data
	var target_idx: int
	if((global_position.y + at_position.y) < dragging_task_target.get_global_rect().get_center().y):
		target_idx = dragging_task_target.get_index()
	else:
		target_idx = dragging_task_target.get_index() + 1
	if target_idx > task_to_move.get_index():
		target_idx -= 1
	move_child(task_to_move, target_idx)
