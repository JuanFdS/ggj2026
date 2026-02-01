@tool
extends StaticBody2D

@export var size_in_cells: Vector2i = Vector2i(1, 1):
	set(new_value):
		size_in_cells = new_value.max(Vector2i(1, 1))
		if not is_node_ready():
			await ready
		if not Engine.is_editor_hint():
			return
			
		if owner != null:
			owner.set_editable_instance(self, true)
		
		var size = 32 * Vector2(size_in_cells)
		$Mask/Sprite2D.texture.width = size.x
		$Mask/Sprite2D.texture.height = size.y
		
		$CollisionPolygon2D.polygon = PackedVector2Array(
			[
				Vector2(0, 0),
				Vector2(size.x, 0),
				Vector2(size.x, size.y),
				Vector2(0, size.y),
			]
		)
