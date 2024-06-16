class_name AnvilAbilityController extends AbilityController

#@onready var anvil_..._upgrade = preload("res://resources/abilities/upgrades/anvil_....tres")

## Initial damage, used for calculate damage upgrades.
@export var base_damage: float = 25

## Used to calculate damage upgrades.
#@export_range(5, 100, 5) var aditional_damage_percent: float = 10

## Time in between ability spawns.
@export_range(0.5, 20, 0.5) var base_wait_time: float = 3

## Max range to spawn anvil.
@export var max_range: float = 120

## Current Ability damage
var current_damage = base_damage

var player: Node2D
var spawn_layer: Node

func _ready():
	$Timer.wait_time = base_wait_time
	$Timer.timeout.connect(on_timer_timeout)
	player = get_tree().get_first_node_in_group('player') as Node2D
	spawn_layer = get_tree().get_first_node_in_group("foreground_layer")


func on_timer_timeout():
	if !player:
		player = get_tree().get_first_node_in_group('player') as Node2D
	
	var direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var spawn_position = player.global_position + (direction * randf_range(0, max_range))
	
	var query_parameters = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position, 1 << 0)
	var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters)
	
	if !result.is_empty():
		spawn_position = result["position"]
	
	var anvil_instance: AnvilAbility = ability_scene.instantiate()
	spawn_layer.add_child(anvil_instance)
	anvil_instance.global_position = spawn_position
	anvil_instance.hitbox_component.damage = current_damage
