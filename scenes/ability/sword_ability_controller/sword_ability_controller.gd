extends Node

@onready var sword_rate_upgrade = preload("res://resources/abilities/upgrades/sword_rate.tres")
@onready var sword_damage_upgrade = preload("res://resources/abilities/upgrades/sword_damage.tres")
@onready var l_hand = %LHand
@onready var r_hand = %RHand

@export var sword_ability: PackedScene
@export var base_ability_resource: Resource
@export var max_range: float = 150
@export var base_damage: int = 5
@export var aditional_damage_percent: float = 1
@export var base_wait_time: float = 1.5

var instances = []
var player: Player

@export var SPAWN_AT_PLAYER: bool = false

func _ready():
	$Timer.wait_time = base_wait_time
	$Timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)


func _process(_delta):
	if SPAWN_AT_PLAYER:
		for instance in instances:
			if !is_instance_valid(instance):
				instances.erase(instance)
				continue
			instance.global_position = r_hand.global_position
			instance.scale.x = 1 if player.visuals.scale.x > 0 else -1


func upgrade_ability(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	var value = upgrade.value / 100
	match upgrade.id:
		sword_rate_upgrade.id:
			var current_level = current_upgrades[sword_rate_upgrade.id]["quantity"]
			var percent_reduction = current_level * value
			$Timer.wait_time = base_wait_time * (1 - percent_reduction)
			$Timer.start()
		sword_damage_upgrade.id:
			aditional_damage_percent *= (1 + value)


func _spawn_at_enemies():
	if sword_ability == null:
		return

	player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return

	var enemies = get_tree().get_nodes_in_group("enemy")
	enemies = enemies.filter(func(enemy: Node2D):
		return enemy.global_position.distance_squared_to(player.global_position) < pow(max_range, 2)
	)

	if enemies.size() == 0:
		return

	enemies.sort_custom(func(a: Node2D, b: Node2D):
		var a_distance = a.global_position.distance_squared_to(player.global_position)
		var b_distance = b.global_position.distance_squared_to(player.global_position)
		return a_distance < b_distance
	)

	var sword_instance = sword_ability.instantiate() as SwordAbility
	player.get_parent().add_child(sword_instance)
	sword_instance.hitbox_component.damage = base_damage * aditional_damage_percent

	sword_instance.global_position = enemies[0].global_position
	sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU)) * 4
	
	var enemy_direction = enemies[0].global_position - sword_instance.global_position
	sword_instance.rotation = enemy_direction.angle()


func _spawn_at_player():
	if sword_ability == null:
		return

	player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return

	var sword_instance = sword_ability.instantiate() as SwordAbility
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
	foreground_layer.add_child(sword_instance)
	sword_instance.hitbox_component.damage = base_damage * aditional_damage_percent

	sword_instance.global_position = r_hand.global_position
	instances.append(sword_instance)


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id.begins_with(base_ability_resource.id):
		upgrade_ability(upgrade, current_upgrades)


func on_timer_timeout():
	if SPAWN_AT_PLAYER:  
		_spawn_at_player()
	else:
		_spawn_at_enemies()
