@tool
extends CollisionObject2D

@onready var sprite_2d: Sprite2D = $Mask/Sprite2D

@export var size_in_cells: Vector2i = Vector2i(1, 1):
	set(new_value):
		size_in_cells = new_value.max(Vector2i(1, 1))
		if not is_node_ready():
			await ready
		if not Engine.is_editor_hint():
			return
		update_based_on_size_in_cells()

@export var texture: Texture2D :
	set(new_value):
		texture = new_value
		if not is_node_ready():
			await ready
		if not Engine.is_editor_hint():
			return
		sprite_2d.texture = texture
		update_based_on_size_in_cells()

func update_based_on_size_in_cells():
	if owner != null:
		owner.set_editable_instance(self, true)
	
	var size = 32 * Vector2(size_in_cells)
	#if $Mask/Sprite2D.texture is GradientTexture2D:
		#$Mask/Sprite2D.texture.width = size.x
		#$Mask/Sprite2D.texture.height = size.y
		#$Mask/Sprite2D.region_enabled = false
	#elif $Mask/Sprite2D.texture is CompressedTexture2D:
		#$Mask/Sprite2D.region_enabled = true
		#$Mask/Sprite2D.region_rect = Rect2(0, 0, size.x, size.y)
	
	$CollisionPolygon2D.polygon = PackedVector2Array(
		[
			Vector2(0, 0),
			Vector2(size.x, 0),
			Vector2(size.x, size.y),
			Vector2(0, size.y),
		]
	)
