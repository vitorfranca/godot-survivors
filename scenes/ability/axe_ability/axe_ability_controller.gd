class_name AxeAbilityController extends AbilityController

@onready var axe_damage_upgrade = preload("res://resources/abilities/upgrades/axe_damage.tres")
@onready var axe_rate_upgrade = preload("res://resources/abilities/upgrades/axe_rate.tres")

## Initial damage, used for calculate damage upgrades
@export var base_damage: float = 10

## Used to calculate damage upgrades
@export_range(5, 100, 5) var aditional_damage_percent: float = 20

## Time in between ability spawns
@export_range(0.5, 20, 0.5) var base_wait_time: float = 5

## Current Ability damage
var current_damage = base_damage


func _ready():
	base_ability = load("res://resources/abilities/axe.tres")
	ability_scene = load("res://scenes/ability/axe_ability/axe_ability.tscn")
	$Timer.timeout.connect(on_timer_timeout)
	$Timer.wait_time = base_wait_time
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)


func spawn_ability():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var foreground = get_tree().get_first_node_in_group("foreground_layer") as Node2D
	if foreground == null:
		return
	
	var axe_instance = ability_scene.instantiate() as AxeAbility
	foreground.add_child(axe_instance)
	axe_instance.global_position = player.global_position
	axe_instance.hitbox_component.damage = ceilf(current_damage)


func upgrade_ability(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	var value = upgrade.value / 100
	var current_level = current_upgrades[upgrade.id]["quantity"]
	match upgrade.id:
		axe_rate_upgrade.id:
			var percent_reduction = current_level * value
			$Timer.wait_time = base_wait_time * (1 - percent_reduction)
			$Timer.start()
		axe_damage_upgrade.id:
			aditional_damage_percent = pow(1 + value, current_level)
			current_damage = base_damage * aditional_damage_percent


func on_timer_timeout():
	spawn_ability()

