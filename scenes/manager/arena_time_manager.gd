extends Node
class_name ArenaTimeManager

signal arena_timer_timeout

@onready var timer = $Timer

func _ready():
	timer.timeout.connect(on_timer_timeout)


func get_time_elapsed():
	return timer.wait_time - timer.time_left


func on_timer_timeout():
	arena_timer_timeout.emit()
