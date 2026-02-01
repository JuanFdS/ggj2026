@tool
extends Sprite2D

@export var subviewport: SubViewport

@export_tool_button("tuki") var tuki: Callable = asdfjadsfads
@export var image_texture: ImageTexture

func asdfjadsfads():
	texture = subviewport.get_texture()
	image_texture = ImageTexture.new()
	image_texture.set_image(texture.get_image())
	texture = image_texture
