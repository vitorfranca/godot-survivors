class_name AbilityController extends Node

## Scene that the AbilityController will spawn
@export var ability_scene: PackedScene

## Base ability of an Ability Upgrade Resource.[br]i.e.: [Axe Damage Upgrade]'s base ability is [Axe].
var base_ability: Resource


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id.begins_with(base_ability.id):
		upgrade_ability(upgrade, current_upgrades)


func upgrade_ability(_upgrade: AbilityUpgrade, _current_upgrades: Dictionary):
	push_error("Method not defined: upgrade_ability.")
