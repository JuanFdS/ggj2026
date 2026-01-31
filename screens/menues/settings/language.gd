@tool
extends MarginContainer

func _ready() -> void:
	%LanguageSelection.configure({
		"English": "en",
		"Spanish": "es",
		"French": "fr",
		"German": "de",
		"Italian": "it",
		"Portuguese": "pt",
		"Russian": "ru",
		"Japanese": "ja",
		"Chinese": "zh",
	},
	"en",
	func(locale):
		TranslationServer.set_locale(locale))
