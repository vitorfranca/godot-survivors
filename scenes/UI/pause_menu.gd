extends CanvasLayer

@onready var panel_container: PanelContainer = %PanelContainer
var options_menu_scene = preload("res://scenes/ui/options_menu.tscn")
var is_closing = false


func _ready():
	get_tree().paused = true
	panel_container.pivot_offset = panel_container.size / 2
	
	%ResumeButton.pressed.connect(on_resume_pressed)
	$AnimationPlayer.play("default")
	%OptionsButton.pressed.connect(on_options_pressed)
	%QuitButton.pressed.connect(on_quit_pressed)
	
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0)
	tween.tween_property(panel_container, "scale", Vector2.ONE, .3)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)


func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		close()
		get_tree().root.set_input_as_handled()


func close():
	if is_closing:
		return
	is_closing = true
	$AnimationPlayer.play_backwards("default")
	
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ONE, 0)
	tween.tween_property(panel_container, "scale", Vector2.ZERO, .3)\
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	
	await tween.finished
	queue_free()
	get_tree().paused = false


func on_resume_pressed():
	close()


func on_options_pressed():
	var options_menu_instance = options_menu_scene.instantiate()
	add_child(options_menu_instance)
	options_menu_instance.back_pressed.connect(on_options_back_pressed.bind(options_menu_instance))


func on_options_back_pressed(options_menu_instance: Node):
	options_menu_instance.queue_free()


func on_quit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")

