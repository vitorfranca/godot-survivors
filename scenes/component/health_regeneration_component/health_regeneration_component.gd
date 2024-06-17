class_name HealthRegenerationComponent extends Node

@export var health_component: HealthComponent

@onready var timer = $Timer

const health_regeneration_upgrade = preload("res://resources/meta_upgrades/health_regeneration.tres")

var health_regeneration_level = 0

func _ready():
	health_regeneration_level = MetaProgression.get_upgrade_quantity(health_regeneration_upgrade.id)
	timer.timeout.connect(on_timer_timeout)
	timer.start()


func on_timer_timeout():
	health_component.heal(health_regeneration_level / 2)

