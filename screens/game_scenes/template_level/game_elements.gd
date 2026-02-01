@tool
extends Node2D

func other():
	if get_parent() == %Layer:
		return %Mask/GameElements
	else:
		return %Layer/GameElements

func _draw() -> void:
	if Engine.is_editor_hint():
		for child in other().get_children():
			var sprites_2d = child.find_children("", "Sprite2D", true, false)
			if not sprites_2d.is_empty():
				var sprite_2d: Sprite2D = sprites_2d.front()
				var modulate_color = Color(0.5,0.5,0.5,0.2)
				var local_sprite_position = other().to_local(sprite_2d.global_position)
				if sprite_2d.centered:
					draw_texture(sprite_2d.texture, local_sprite_position - sprite_2d.texture.get_size() / 2.0, modulate_color)
				else:
					draw_texture(sprite_2d.texture, local_sprite_position, modulate_color)
			else:
				draw_circle(child.position, 5.0, Color.YELLOW)

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		queue_redraw()
