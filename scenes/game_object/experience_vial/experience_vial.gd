extends Node2D

@onready var collision_shape_2d = $Area2D/CollisionShape2D
@onready var sprite = $Sprite2D


func _ready():
	$Area2D.area_entered.connect(on_area_entered)


func tween_collect(percent: float, start_position: Vector2):
	var player = get_tree().get_first_node_in_group("player") as Player
	if player == null:
		push_error("Player is null in ExperienceVial Scene.")
		return
	
	global_position = start_position.lerp(player.global_position, percent)
	var direction_from_start = player.global_position - start_position
	
	var target_rotation = direction_from_start.angle() + deg_to_rad(90)
	rotation = lerp_angle(rotation, target_rotation, 1 - exp(-3 * get_process_delta_time()))
	

func collect_vial():
	GameEvents.emit_experience_collected(1)
	queue_free()
	

func disable_collision():
	collision_shape_2d.disabled = true

func on_area_entered(_area: Area2D):
	Callable(disable_collision).call_deferred()
	
	var tween = create_tween()
	const DURATION = .8
	
	# Run all tweens in parallel
	tween.set_parallel()
	tween.tween_method(tween_collect.bind(global_position), 0.0, 1.0, DURATION)\
		.set_ease(Tween.EASE_IN)\
		.set_trans(Tween.TRANS_BACK)
	tween.tween_property(sprite, "scale", Vector2.ZERO, DURATION * .1)\
		.set_delay(DURATION * .9)
	
	# Wait for all the previous tweens are finished before running the next one
	tween.chain()
	tween.tween_callback(collect_vial)
	
