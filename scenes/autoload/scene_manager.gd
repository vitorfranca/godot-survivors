extends Node

var main_scene = preload("res://scenes/main/main.tscn")

func load_main_scene(transition: bool = true):
	ScreenTransition.transition()
	await ScreenTransition.transition_half
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")
