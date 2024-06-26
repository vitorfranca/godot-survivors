extends Node

signal experience_collected(number: float)
signal ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary)
signal player_damaged()
signal defeat
signal victory


func emit_experience_collected(number: float):
	experience_collected.emit(number)


func emit_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	ability_upgrade_added.emit(upgrade, current_upgrades)


func emit_player_damaged():
	player_damaged.emit()


func emit_defeat():
	defeat.emit()


func emit_victory():
	victory.emit()

