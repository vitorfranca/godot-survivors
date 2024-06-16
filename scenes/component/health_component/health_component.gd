extends Node
class_name HealthComponent

signal died
signal health_updated(value: float)

@export var max_health: float = 10

var current_health: float

func _ready() -> void:
	current_health = max_health


func damage(damage_amount: float) -> void:
	current_health = max(0, current_health - damage_amount)
	_emit_health_updated(-1 * damage_amount)


func heal(heal_amount: float):
	current_health = min(max_health, current_health + heal_amount)
	_emit_health_updated(heal_amount)
	

func heal_percentage(percentage: float):
	current_health = min(max_health, max_health * (1 + percentage))
	_emit_health_updated(max_health * (1 + percentage))


func update_max_health_percentage(percentage: float):
	var multiplicator = 1 + percentage
	var value = max_health * multiplicator
	max_health = max(0, max_health * value)
	_emit_health_updated(max_health * value)
	

func update_max_health(amount: float):
	max_health += amount
	_emit_health_updated(amount)

func _emit_health_updated(amount: float):
	health_updated.emit(amount)
	Callable(check_death).call_deferred()

func check_death():
	if current_health <= 0:
		died.emit()
		owner.queue_free()


func get_health_percentage():
	if max_health <= 0:
		return 0
	return min(current_health / max_health, 1)
