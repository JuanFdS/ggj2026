@tool
extends Button

const TaskList = preload("uid://m6l1gmw6puky")
const TaskDragPreview = preload("uid://cfsvfcxa7v20u")

@onready var task = $"../.."

func _get_drag_data(at_position: Vector2) -> Variant:
	if disabled:
		return

	var dragged_task = TaskDragPreview.from(task)
	set_drag_preview(dragged_task)

	return task
