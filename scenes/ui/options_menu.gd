extends CanvasLayer

signal back_pressed

@onready var window_button: Button = %WindowButton
@onready var sfx_slider = %SFXSlider
@onready var music_slider = %MusicSlider


func _ready():
	window_button.pressed.connect(on_window_button_pressed)
	%BackButton.pressed.connect(on_back_button_pressed)
	sfx_slider.value_changed.connect(on_audio_slider_changed.bind('sfx'))
	music_slider.value_changed.connect(on_audio_slider_changed.bind('music'))
	update_display()


func update_display():
	sfx_slider.value = get_bus_volume_percent('sfx')
	music_slider.value = get_bus_volume_percent('music')
	
	var mode = DisplayServer.window_get_mode()
	match mode:
		DisplayServer.WINDOW_MODE_FULLSCREEN:
			window_button.text = "Fullscreen"
		DisplayServer.WINDOW_MODE_WINDOWED:
			window_button.text = "Windowed"


func get_bus_volume_percent(bus_name: String):
	var bus_index = AudioServer.get_bus_index(bus_name)
	var volume_db = AudioServer.get_bus_volume_db(bus_index)
	var volume_linear = db_to_linear(volume_db)
	return volume_linear


func set_bus_volume_percent(bus_name: String, percent: float):
	var bus_index = AudioServer.get_bus_index(bus_name)
	var volume_db = linear_to_db(percent)
	AudioServer.set_bus_volume_db(bus_index, volume_db)


func on_audio_slider_changed(value: float, bus_name: String):
	set_bus_volume_percent(bus_name, value)


func on_window_button_pressed():
	var mode = DisplayServer.window_get_mode()
	match mode:
		DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.WINDOW_MODE_WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	
	update_display()


func on_back_button_pressed():
	back_pressed.emit()

