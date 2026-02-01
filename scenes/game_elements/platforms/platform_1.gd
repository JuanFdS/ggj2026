@tool
extends StaticBody2D

@export var size_in_cells: Vector2i = Vector2i(1, 1):
	set(new_value):
		size_in_cells = new_value.max(Vector2i(1, 1))
		if not is_node_ready():
			await ready
		
		var size = 32 * Vector2(size_in_cells)
		$Mask/Sprite2D.texture.width = size.x
		$Mask/Sprite2D.texture.height = size.y
		
		$Mask.position = size / 2
		$CollisionShape2D.position = size / 2
		$CollisionShape2D.shape.size = size
