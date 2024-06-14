extends Node

@export_range(0, 1, 0.05) var drop_percent: float = .5
@export var health_component: HealthComponent
@export var vial_scene: PackedScene

const experience_gain = preload("res://resources/meta_upgrades/experience_gain.tres")


func _ready():
	if health_component != null:
		health_component.died.connect(on_died)


func on_died():
	var adjusted_drop_percent = drop_percent
	var experience_gain_upgrade_quantity = MetaProgression.get_upgrade_quantity(experience_gain.id)
	if experience_gain_upgrade_quantity > 0:
		adjusted_drop_percent = adjusted_drop_percent * (1 + experience_gain.value)
	
	if randf() > adjusted_drop_percent:
		return
	if vial_scene == null:
		return
	if not owner is Node2D:
		return
	
	var spawn_position = (owner as Node2D).global_position
	var vial_instance = vial_scene.instantiate() as Node2D
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(vial_instance)
	vial_instance.global_position = spawn_position
