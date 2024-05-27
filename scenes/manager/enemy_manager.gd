extends Node
class_name EnemyManager

const SPAWN_RADIUS = 350

@export var base_spawn_time: float = 1
@export var spawn_time_decrease_step: float = 0.1
@export var min_spawn_time: float = 0.3
@export var spawn_enemy_scene: PackedScene
@export var arena_time_manager: ArenaTimeManager

@onready var timer = $Timer

func _ready():
	push_error("ArenaTimeManager is null in EnemyManager Node.")
	assert(arena_time_manager != null)
	timer.timeout.connect(on_timer_timeout)
	timer.wait_time = base_spawn_time
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)


func get_spawn_position() -> Vector2:
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return Vector2.ZERO
		
	var spawn_position = Vector2.ZERO
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	
	for i in 4:
		spawn_position = player.global_position + (random_direction * SPAWN_RADIUS)
		
		var query_parameters = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position, 1 << 0)
		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters)
	
		if result.is_empty():
			# spawn_position is inside the arena
			break
		else: 
			# spawn_position is outside the arena
			random_direction = random_direction.rotated(deg_to_rad(90))
			
	return spawn_position

func spawn_enemy():
	var enemy = spawn_enemy_scene.instantiate() as Node2D
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(enemy)
	enemy.global_position = get_spawn_position()
	
	
func on_timer_timeout():
	timer.start()
	spawn_enemy()


func on_arena_difficulty_increased(arena_difficulty: int):
	var level_time = arena_time_manager.timer.wait_time
	var number_of_increases = level_time / arena_time_manager.DIFFICULTY_INTERVAL
	var time_off = (spawn_time_decrease_step / number_of_increases) * arena_difficulty
	timer.wait_time = max(timer.wait_time - time_off, min_spawn_time)
	
