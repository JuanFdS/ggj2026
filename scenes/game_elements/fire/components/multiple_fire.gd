@tool
extends Node2D

const Fire = preload("res://scenes/game_elements/fire/Fire.tscn")

@export var width_in_cells: int = 1:
	set(new_value):
		width_in_cells = new_value
		if not is_node_ready():
			await ready
		
		for child in get_children():
			child.queue_free()
			
		for cell_index in width_in_cells:
			var fire := Fire.instantiate()
			fire.position.x = cell_index * 32
			
			add_child(fire)
		
