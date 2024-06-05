extends Node
class_name UpgradeManager

@export var experience_manager: ExperienceManager
@export var upgrade_screen_scene: PackedScene

var current_upgrades = {}
var upgrade_pool: WeightedTable = WeightedTable.new()

var upgrade_axe = preload("res://resources/abilities/axe.tres")
var upgrade_axe_damage = preload("res://resources/abilities/upgrades/axe_damage.tres")
var upgrade_axe_rate = preload("res://resources/abilities/upgrades/axe_rate.tres")

var upgrade_sword = preload("res://resources/abilities/sword.tres")
var upgrade_sword_rate = preload("res://resources/abilities/upgrades/sword_rate.tres")
var upgrade_sword_damage = preload("res://resources/abilities/upgrades/sword_damage.tres")

var upgrade_player_speed = preload("res://resources/abilities/upgrades/player_speed.tres")

# TODO: Add required_upgrade to ability_upgrade resource
# TODO: Append upgrade to upgrade_pool if its required_upgrade is included


func _ready():
	#_load_upgrades()
	#upgrade_pool.add_item(upgrade_player_speed, 3)
	upgrade_pool.add_item(upgrade_axe, 10)
	upgrade_pool.add_item(upgrade_sword, 10)
	
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
			upgrade_pool.remove_item(upgrade)
	
	update_upgrade_pool(upgrade)
	GameEvents.emit_ability_upgrade_added(upgrade, current_upgrades)


func update_upgrade_pool(chosen_upgrade: AbilityUpgrade):
	match chosen_upgrade.id:
		upgrade_axe.id:
			upgrade_pool.add_item(upgrade_axe_damage, 10)
			upgrade_pool.add_item(upgrade_axe_rate, 10)
		upgrade_sword.id:
			upgrade_pool.add_item(upgrade_sword_damage, 10)
			upgrade_pool.add_item(upgrade_sword_rate, 10)


func select_upgrades() -> Array[AbilityUpgrade]:
	var chosen_upgrades: Array[AbilityUpgrade] = []
	for i in 3:
		if upgrade_pool.items.size() == chosen_upgrades.size():
			break
		var chosen_upgrade = upgrade_pool.pick_item(chosen_upgrades)
		chosen_upgrades.append(chosen_upgrade)
	
	return chosen_upgrades


#func _load_upgrades():
	#var path = "res://resources/abilities/upgrades/"
	#var dir = DirAccess.open(path)
	#var upgrade_regex = RegEx.new()
	#upgrade_regex.compile("(sword.*|axe)\\.tres")
	#dir.list_dir_begin()
	#while true:
		#var file_name = dir.get_next()
		#if file_name == "":
			#break
		#elif upgrade_regex.search(file_name):
			#upgrade_pool.add_item(load(path + "/" + file_name), 10)
	#dir.list_dir_end()


func on_level_up(_level: int):
	var chosen_upgrades = select_upgrades()
	
	if !chosen_upgrades.is_empty():
		var upgrade_screen_instance = upgrade_screen_scene.instantiate()
		add_child(upgrade_screen_instance)
		upgrade_screen_instance.set_ability_upgrades(chosen_upgrades as Array[AbilityUpgrade])
		upgrade_screen_instance.upgrade_selected.connect(on_upgrade_selected)


func on_upgrade_selected(upgrade: AbilityUpgrade):
	apply_upgrade(upgrade)

