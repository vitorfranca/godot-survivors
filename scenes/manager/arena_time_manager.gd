extends Node
class_name ArenaTimeManager

signal arena_difficulty_increased(arena_difficulty: int)
signal arena_timer_timeout

const DIFFICULTY_INTERVAL = 5

@onready var timer = $Timer

var arena_difficulty: int = 0
var previous_time = 0


func _ready():
	timer.timeout.connect(on_timer_timeout)


func _process(delta):
	var next_time_target = timer.wait_time - ((arena_difficulty + 1) * DIFFICULTY_INTERVAL)
	if timer.time_left <= next_time_target:
		arena_difficulty += 1
		arena_difficulty_increased.emit(arena_difficulty)
		

func get_time_elapsed():
	return timer.wait_time - timer.time_left


func on_timer_timeout():
	arena_timer_timeout.emit()
