extends Node
class_name EndScreenManager

@onready var player = %Player
@onready var arena_time_manager: ArenaTimeManager = $"../ArenaTimeManager"

@export var end_screen_scene: PackedScene

func _ready():
	await player.ready
	player.health_component.died.connect(on_player_died)
	arena_time_manager.arena_timer_timeout.connect(on_arena_timer_timeout)


func show_defeat_screen():
	var end_screen_instance = end_screen_scene.instantiate()
	add_child(end_screen_instance)
	end_screen_instance.set_defeat()


func show_victory_screen():
	var end_screen_instance = end_screen_scene.instantiate()
	add_child(end_screen_instance)
	end_screen_instance.set_victory()


func on_player_died():
	show_defeat_screen()


func on_arena_timer_timeout():
	show_victory_screen()
