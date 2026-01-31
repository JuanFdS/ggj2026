@tool
extends Control

const TaskDragPreview = preload("uid://cfsvfcxa7v20u")
const TaskList = preload("uid://m6l1gmw6puky")
const Task = preload("uid://27jy1dvchw51")

var task_list: TaskList :
	get():
		return task.task_list()
var line_origin: Vector2
var line_end: Vector2
var task: Task

static func from(a_task):
	var preview_task = a_task.duplicate()
	preview_task.set_script(TaskDragPreview)
	preview_task.task = a_task
	preview_task.size = a_task.size
	return preview_task 

func _exit_tree() -> void:
	task_list.dragging_position = null

func _process(delta: float) -> void:
	task_list.dragging_position = global_position
	queue_redraw()

func _draw() -> void:
	draw_line(line_origin, line_end, Color.WHITE, 5)
