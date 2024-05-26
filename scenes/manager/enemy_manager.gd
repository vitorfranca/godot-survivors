extends Node

@export var spawn_time: float = 1
@export var spawn_enemy_scene: PackedScene

const SPAWN_RADIUS = 330

func _ready():
	$Timer.timeout.connect(on_timer_timeout)
	$Timer.wait_time = spawn_time


func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var spawn_position = player.global_position + (random_direction * SPAWN_RADIUS)
	
	var enemy = spawn_enemy_scene.instantiate() as Node2D
	
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(enemy)
	enemy.global_position = spawn_position
