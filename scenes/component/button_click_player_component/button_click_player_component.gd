extends Node

@onready var button_down_player = $ButtonDownPlayer
@onready var button_up_player = $ButtonUpPlayer


func _ready():
	var parent: Node = get_parent()
	if parent.button_down:
		parent.button_down.connect(on_button_down)
	if parent.button_up:
		parent.button_up.connect(on_button_up) 


func on_button_down():
	print("on_button_down")
	button_down_player.play()
	
	
func on_button_up():
	print("on_button_up")
	button_up_player.play()

