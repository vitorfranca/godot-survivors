class_name AnvilAbilityController extends AbilityController

## Initial damage, used for calculate damage upgrades.
@export var base_damage: float = 50

## Used to calculate damage upgrades.
#@export_range(5, 100, 5) var aditional_damage_percent: float = 10

## Time in between ability spawns.
@export_range(0.5, 20, 0.5) var base_wait_time: float = 3

## Max range to spawn anvil.
@export var max_range: float = 120

## Max range to spawn anvil.
@export var min_range: float = 20

@onready var anvil_amount_upgrade = preload("res://resources/abilities/upgrades/anvil_amount.tres")
@onready var anvil_area_upgrade = 	preload("res://resources/abilities/upgrades/anvil_area.tres")


## Current Ability damage
var current_damage = base_damage

var player: Node2D
var spawn_layer: Node
var anvil_amount: int = 1
var increased_anvil_area: int = 0

func _ready():
	$Timer.wait_time = base_wait_time
	$Timer.timeout.connect(on_timer_timeout)
	player = get_tree().get_first_node_in_group('player') as Node2D
	spawn_layer = get_tree().get_first_node_in_group("foreground_layer")
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)


func upgrade_ability(upgrade: AbilityUpgrade, _current_upgrades: Dictionary):
	match upgrade.id:
		anvil_amount_upgrade.id:
			anvil_amount += 1
		anvil_area_upgrade.id:
			increased_anvil_area += 24


func on_timer_timeout():
	if !player:
		player = get_tree().get_first_node_in_group('player') as Node2D
	
	var direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var additional_rotation_degrees = 360.0 / anvil_amount
	var anvil_distance = randf_range(min_range, max_range)
	
	for i in anvil_amount:
		var adjusted_direction = direction.rotated(deg_to_rad(additional_rotation_degrees * i))
		
		var spawn_position = player.global_position + (adjusted_direction * anvil_distance)
		
		var query_parameters = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position, 1 << 0)
		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters)
		
		if !result.is_empty():
			spawn_position = result["position"]
		
		var anvil_instance: AnvilAbility = ability_scene.instantiate()
		anvil_instance.set_damage_area(increased_anvil_area)
		spawn_layer.add_child(anvil_instance)
		anvil_instance.global_position = spawn_position
		anvil_instance.hitbox_component.damage = current_damage
