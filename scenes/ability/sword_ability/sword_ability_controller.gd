class_name SwordAbilityController extends AbilityController

@onready var sword_rate_upgrade = preload("res://resources/abilities/upgrades/sword_rate.tres")
@onready var sword_damage_upgrade = preload("res://resources/abilities/upgrades/sword_damage.tres")
var l_hand: Marker2D
var r_hand: Marker2D

## Initial damage, used for calculate damage upgrades.
@export var base_damage: float = 5

## Used to calculate damage upgrades.
@export_range(5, 100, 5) var aditional_damage_percent: float = 10

## Time in between ability spawns.
@export_range(0.5, 20, 0.5) var base_wait_time: float = 3

## Max enemy distance to attack.
@export var max_range: float = 120

enum AttackType {SpawnAtPlayer, SpawnAtEnemy}
## Sword spawns at player hand or at the enemy
@export var attack_type: AttackType = AttackType.SpawnAtEnemy

## Current Ability damage
var current_damage = base_damage

var instances = []
var player: Player

func _ready():
	ability_scene = load("res://scenes/ability/sword_ability/sword_ability.tscn")
	$Timer.wait_time = base_wait_time
	$Timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	player = get_tree().get_first_node_in_group('player')
	l_hand = player.get_node("%LHand")
	r_hand = player.get_node("%RHand")


func _process(_delta):
	if attack_type == AttackType.SpawnAtPlayer:
		for instance in instances:
			if !is_instance_valid(instance):
				instances.erase(instance)
				continue
			instance.global_position = r_hand.global_position
			instance.scale.x = 1 if player.visuals.scale.x > 0 else -1


func upgrade_ability(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	var value = upgrade.value / 100
	var current_level = current_upgrades[upgrade.id]["quantity"]
	match upgrade.id:
		sword_rate_upgrade.id:
			var percent_reduction = current_level * value
			$Timer.wait_time = base_wait_time * (1 - percent_reduction)
			$Timer.start()
		sword_damage_upgrade.id:
			aditional_damage_percent = pow(1 + value, current_level)
			current_damage = base_damage * aditional_damage_percent


func spawn_ability():
	if attack_type == AttackType.SpawnAtPlayer:  
		_spawn_at_player()
	else:
		_spawn_at_enemies()


func _spawn_at_enemies():
	if ability_scene == null:
		push_error("ability_scene is null in SwordAbilityController.")
		return

	player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		push_error("Player is null in SwordAbilityController.")
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

	var sword_instance = ability_scene.instantiate() as SwordAbility
	player.get_parent().add_child(sword_instance)
	sword_instance.hitbox_component.damage = ceilf(current_damage)

	sword_instance.global_position = enemies[0].global_position
	sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU)) * 4
	
	var enemy_direction = enemies[0].global_position - sword_instance.global_position
	sword_instance.rotation = enemy_direction.angle()


func _spawn_at_player():
	if ability_scene == null:
		return

	player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return

	var sword_instance = ability_scene.instantiate() as SwordAbility
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
	foreground_layer.add_child(sword_instance)
	sword_instance.hitbox_component.damage = ceilf(current_damage)

	sword_instance.global_position = r_hand.global_position
	instances.append(sword_instance)


func on_timer_timeout():
	spawn_ability()
