extends Node
class_name UpgradeManager

@export var upgrade_pool: Array[AbilityUpgrade]
@export var experience_manager: ExperienceManager
@export var upgrade_screen_scene: PackedScene

var current_upgrades = {}

func _ready():
	experience_manager.level_up.connect(on_level_up)


func apply_upgrade(upgrade: AbilityUpgrade):		
	var has_upgrade = current_upgrades.has(upgrade.id)
	if !has_upgrade:
		current_upgrades[upgrade.id] = {
			"resource": upgrade,
			"quantity": 1,
		}
	else:
		current_upgrades[upgrade.id]["quantity"] += 1
	
	if upgrade.max_level > 0:
		var current_level = current_upgrades[upgrade.id]["quantity"]
		
		# If upgrade is in max level remove from upgrade pool
		if current_level == upgrade.max_level:
			upgrade_pool = upgrade_pool.filter(func(pool_upgrade): return pool_upgrade.id != upgrade.id)
	
	GameEvents.emit_ability_upgrade_added(upgrade, current_upgrades)


func select_upgrades() -> Array[AbilityUpgrade]:
	var chosen_upgrades: Array[AbilityUpgrade] = []
	var filtered_upgrades = upgrade_pool.duplicate()
	if filtered_upgrades.size() == 0:
		return chosen_upgrades
	
	for i in min(filtered_upgrades.size(), 3):
		var chosen_upgrade = filtered_upgrades.pick_random() as AbilityUpgrade
		if chosen_upgrade == null: 
			break
			
		chosen_upgrades.append(chosen_upgrade)
		filtered_upgrades = filtered_upgrades.filter(
			func(upgrade): 
				return upgrade.id != chosen_upgrade.id
		)
	return chosen_upgrades


func on_level_up(_level: int):
	var chosen_upgrades = select_upgrades()
		
	var upgrade_screen_instance = upgrade_screen_scene.instantiate()
	add_child(upgrade_screen_instance)
	upgrade_screen_instance.set_ability_upgrades(chosen_upgrades)
	upgrade_screen_instance.upgrade_selected.connect(on_upgrade_selected)


func on_upgrade_selected(upgrade: AbilityUpgrade):
	apply_upgrade(upgrade)
