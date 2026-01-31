@tool
extends MarginContainer

func _ready() -> void:
	%WindowMode.configure({
		"window_mode_exclusive_fullscreen": Window.MODE_EXCLUSIVE_FULLSCREEN,
		"window_mode_fullscreen": Window.MODE_FULLSCREEN,
		"window_mode_maximized": Window.MODE_MAXIMIZED,
		"window_mode_minimized": Window.MODE_WINDOWED,
	},
	Window.MODE_WINDOWED,
	func(windows_mode):
		get_window().mode = windows_mode)
	
	%Resolution.configure({
		"1920x1080": Vector2i(1920, 1080),
		"1280x720": Vector2i(1280, 720),
		"2560x1440": Vector2i(2560, 1440),
		"3840x2160": Vector2i(3840, 2160),
	},
	Vector2i(1920, 1080),
	func(resolution):
		get_window().size = resolution)
	
	%VSync.configure({
		"Disabled": DisplayServer.VSYNC_DISABLED,
		"Enabled": DisplayServer.VSYNC_ENABLED,
		"Adaptive": DisplayServer.VSYNC_ADAPTIVE,
		"Mailbox": DisplayServer.VSYNC_MAILBOX,
	},
	DisplayServer.VSYNC_ENABLED,
	func(vsync_mode):
		DisplayServer.window_set_vsync_mode(vsync_mode))
	
	%FPSLimit.configure({
		"30 FPS": 30,
		"60 FPS": 60,
		"120 FPS": 120,
		"144 FPS": 144,
		"Unlimited": 0,
	},
	60,
	func(fps_limit):
		Engine.max_fps = fps_limit)
	
	%AntiAliasing.configure({
		"Disabled": Viewport.MSAA_DISABLED,
		"2x MSAA": Viewport.MSAA_2X,
		"4x MSAA": Viewport.MSAA_4X,
		"8x MSAA": Viewport.MSAA_8X,
	},
	Viewport.MSAA_DISABLED,
	func(msaa_mode):
		get_viewport().msaa_3d = msaa_mode)
	
	%ShadowQuality.configure({
		"Low": RenderingServer.SHADOW_QUALITY_SOFT_LOW,
		"Medium": RenderingServer.SHADOW_QUALITY_SOFT_MEDIUM,
		"High": RenderingServer.SHADOW_QUALITY_SOFT_HIGH,
		"Ultra": RenderingServer.SHADOW_QUALITY_SOFT_ULTRA,
	},
	RenderingServer.SHADOW_QUALITY_SOFT_MEDIUM,
	func(shadow_quality):
		RenderingServer.directional_soft_shadow_filter_set_quality(shadow_quality)
		RenderingServer.positional_soft_shadow_filter_set_quality(shadow_quality))
	
	%TextureQuality.configure({
		"Low": 2.0,
		"Medium": 1.0,
		"High": 0.5,
		"Ultra": 0.0,
	},
	1.0,
	func(mipmap_bias):
		get_viewport().texture_mipmap_bias = mipmap_bias)
	
	%GraphicsPreset.configure({
		"Low": "low",
		"Medium": "medium",
		"High": "high",
		"Ultra": "ultra",
	},
	"medium",
	func(preset):
		_apply_graphics_preset(preset))

func _apply_graphics_preset(preset: String) -> void:
	match preset:
		"low":
			%VSync.option_button.select(0)
			%FPSLimit.option_button.select(0)
			%AntiAliasing.option_button.select(0)
			%ShadowQuality.option_button.select(0)
			%TextureQuality.option_button.select(0)
		"medium":
			%VSync.option_button.select(1)
			%FPSLimit.option_button.select(1)
			%AntiAliasing.option_button.select(0)
			%ShadowQuality.option_button.select(1)
			%TextureQuality.option_button.select(1)
		"high":
			%VSync.option_button.select(1)
			%FPSLimit.option_button.select(2)
			%AntiAliasing.option_button.select(2)
			%ShadowQuality.option_button.select(2)
			%TextureQuality.option_button.select(2)
		"ultra":
			%VSync.option_button.select(1)
			%FPSLimit.option_button.select(3)
			%AntiAliasing.option_button.select(3)
			%ShadowQuality.option_button.select(3)
			%TextureQuality.option_button.select(3)
