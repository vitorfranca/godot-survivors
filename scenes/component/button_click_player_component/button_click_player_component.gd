extends Node

@onready var button_down_player = $ButtonDownPlayer
@onready var button_up_player = $ButtonUpPlayer


func _ready():
	var parent: Node = get_parent()
	if parent.has_signal("button_down"):
		parent.button_down.connect(on_button_down)
	if parent.has_signal("button_up"):
		parent.button_up.connect(on_button_up)
	if parent.has_signal("drag_started"):
		parent.drag_started.connect(on_button_down)
	if parent.has_signal("drag_ended"):
		print("drag_ended")
		parent.drag_ended.connect(on_drag_ended)


func on_button_down():
	button_down_player.play()


func on_button_up():
	button_up_player.play()


func on_drag_ended(_value_changed: bool):
	on_button_up()
