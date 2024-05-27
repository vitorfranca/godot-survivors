extends Node2D
class_name AxeAbility

const MAX_RADIUS = 100

@onready var hitbox_component = $HitboxComponent

var base_rotation = Vector2.RIGHT
var player_initial_position: Vector2 = Vector2.ZERO

func _ready():
	base_rotation = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var tween = create_tween()
	tween.tween_method(tween_method, 0.0, 2.0, 2)
	tween.tween_callback(queue_free)
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	player_initial_position = player.global_position


func tween_method(rotations: float):
	var percentage = rotations / 2
	var current_radius = percentage * MAX_RADIUS
	var current_direction = base_rotation.rotated(rotations * TAU)
	global_position = player_initial_position + (current_direction * current_radius)
