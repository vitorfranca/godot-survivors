extends CanvasLayer

@onready var restart_button = %RestartButton
@onready var quit_button = %QuitButton


func _ready():
	get_tree().paused = true
	restart_button.pressed.connect(on_restart_button_pressed)
	quit_button.pressed.connect(on_quit_button_pressed)

func set_victory():
	%TitleLabel.text = "Victory"
	%DescriptionLabel.text = "You won!"
	
func set_defeat():
	%TitleLabel.text = "Defeat"
	%DescriptionLabel.text = "You lost!"
	

func on_restart_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")
	

func on_quit_button_pressed():
	get_tree().quit()
