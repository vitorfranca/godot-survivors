class_name Player
extends CharacterBody2D

@onready var damage_interval_timer = $DamageIntervalTimer
@onready var health_component: HealthComponent = $HealthComponent
@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var health_bar = $HealthBar
@onready var abilities = $Abilities
@onready var animation_player = $AnimationPlayer
@onready var visuals = $Visuals

@export var experience_manager: ExperienceManager

var upgrade_player_speed = preload("res://resources/abilities/upgrades/player_speed.tres")

var number_colliding_bodies = 0
var move_sign = 0


func _ready():
	$CollisionArea2D.body_entered.connect(on_body_entered)
	$CollisionArea2D.body_exited.connect(on_body_exited)
	damage_interval_timer.timeout.connect(on_damage_interval_timer_timeout)
	health_component.health_updated.connect(on_health_updated)
	experience_manager.level_up.connect(on_level_up)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	update_health_display()


func _process(_delta):
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	velocity_component.accelerate_in_direction(direction)
	velocity_component.move(self)
	
	if movement_vector.x != 0 || movement_vector.y != 0:
		animation_player.play("walk")
	else:
		animation_player.play("RESET")
	
	move_sign = sign(movement_vector.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1)


func get_movement_vector() -> Vector2:
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	return Vector2(x_movement, y_movement)


func check_deal_damage():
	if number_colliding_bodies == 0 || !damage_interval_timer.is_stopped():
		return
	
	health_component.damage(1)
	damage_interval_timer.start()


func update_health_display():
	health_bar.value = health_component.get_health_percentage()


func increase_player_health():
	var prev_max_health = health_component.max_health
	health_component.update_max_health_percentage(1.1)
	var health_increase = health_component.max_health - prev_max_health
	health_component.heal(health_increase)
	

# Signal callbacks
func on_body_entered(_body: Node2D):
	number_colliding_bodies += 1
	check_deal_damage()


func on_body_exited(_body: Node2D):
	number_colliding_bodies -= 1


func on_damage_interval_timer_timeout():
	check_deal_damage()


func on_health_updated(amount: float):
	if amount < 0:
		$HitStreamPlayer.play_random()
		GameEvents.emit_player_damaged()
	update_health_display()
	

func on_ability_upgrade_added(ability_upgrade: AbilityUpgrade, _current_upgrades: Dictionary):
	if ability_upgrade is Ability:
		var ability = ability_upgrade as Ability
		abilities.add_child(ability.ability_controller_scene.instantiate())
	else:
		match ability_upgrade.id:
			upgrade_player_speed.id:
				velocity_component.increase_max_speed(upgrade_player_speed.value)


func on_level_up(_new_level: int):
	increase_player_health()
