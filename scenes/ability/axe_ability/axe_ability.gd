class_name AxeAbility extends Node2D

@export var max_radius = 100
@export var total_rotations = 2.0
@export var duration = 2.0

@onready var hitbox_component = $HitboxComponent

var base_rotation = Vector2.RIGHT
var player_initial_position: Vector2 = Vector2.ZERO


func _ready():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	player_initial_position = player.global_position
	
	base_rotation = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var tween = create_tween()
	tween.tween_method(tween_method, 0.0, total_rotations, duration)
	tween.tween_callback(queue_free)


func tween_method(rotations: float):
	var percentage = rotations / 2
	var current_radius = percentage * max_radius
	var current_direction = base_rotation.rotated(rotations * TAU)
	global_position = player_initial_position + (current_direction * current_radius)
