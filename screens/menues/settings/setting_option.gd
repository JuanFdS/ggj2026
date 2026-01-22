@tool
extends HBoxContainer

@export var label_text: String :
	set(new_value):
		label_text = new_value
		if not is_node_ready():
			await ready
		$Label.text = new_value

@onready var option_button: OptionButton = $OptionButton
var values_by_idx: Dictionary[int, Variant]
var on_change: Callable = func(): pass

signal value_selected(value: Variant)

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	option_button.item_selected.connect(func(idx: int):
		var new_value = values_by_idx[idx]
		value_selected.emit(values_by_idx[idx])
		on_change.call(new_value)
	)

func configure(
	possible_values: Dictionary[String, Variant],
	default_value: Variant,
	on_change_callback: Callable
	):
	on_change = on_change_callback
	option_button.clear()
	for key in possible_values.keys():
		option_button.add_item(key)
		var item_idx = option_button.item_count - 1
		var value = possible_values[key]
		values_by_idx[item_idx] = value
		if value == default_value:
			option_button.select(item_idx)
	
