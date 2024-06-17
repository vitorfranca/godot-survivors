class_name AbilityController extends Node

## Scene that the AbilityController will spawn
@export var ability_scene: PackedScene


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	upgrade_ability(upgrade, current_upgrades)


func upgrade_ability(_upgrade: AbilityUpgrade, _current_upgrades: Dictionary):
	push_error("Method not defined: upgrade_ability.")

