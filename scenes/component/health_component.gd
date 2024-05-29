extends Node
class_name HealthComponent

signal died
signal health_updated

@export var max_health: float = 10

var current_health: float

func _ready() -> void:
	current_health = max_health


func damage(damage_amount: float) -> void:
	current_health = max(0, current_health - damage_amount)
	_emit_health_updated()


func heal(heal_amount: float):
	current_health = min(max_health, current_health + heal_amount)
	_emit_health_updated()
	

func heal_percentage(percentage: float):
	current_health = min(max_health, current_health * (1 + percentage))
	_emit_health_updated()


func update_max_health_percentage(percentage: float):
	max_health = max(0, max_health * percentage)
	_emit_health_updated()
	

func update_max_health(amount: float):
	max_health += amount
	_emit_health_updated()

func _emit_health_updated():
	health_updated.emit()
	Callable(check_death).call_deferred()

func check_death():
	if current_health <= 0:
		died.emit()
		owner.queue_free()


func get_health_percentage():
	if max_health <= 0:
		return 0
	return min(current_health / max_health, 1)
