class_name ExperienceManager
extends Node

signal experience_updated(current_experience: float, target_experience: float, current_level: int)
signal level_up(new_level: int)

const TARGET_EXPERIENCE_GROWTH = 3

var current_experience = 0
var current_level = 0
var target_experience = 0

func _ready():
	GameEvents.experience_collected.connect(on_experience_collected)
	Callable(_level_up).call_deferred()


func _level_up():
	target_experience += TARGET_EXPERIENCE_GROWTH
	current_experience = 0
	current_level += 1
	level_up.emit(current_level)


func increment_experience(number: float):
	current_experience = min(current_experience + number, target_experience)
	experience_updated.emit(current_experience, target_experience, current_level)
	
	if current_experience == target_experience:
		_level_up()
		experience_updated.emit(current_experience, target_experience, current_level)


func on_experience_collected(number: float):
	increment_experience(number)
