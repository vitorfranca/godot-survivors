extends Node

const SAVE_FILE_PATH = "user://save.data"

var save_data: Dictionary = {
	"victory_count": 0,
	"defeat_count": 0,
	"meta_upgrade_currency": 0,
	"meta_upgrades": {
	},
}

var meta_upgrade_initial_value = {
	"quantity": 0,
}


func _ready():
	GameEvents.experience_collected.connect(on_experience_gained)
	GameEvents.victory.connect(on_victory)
	GameEvents.defeat.connect(on_defeat)
	load_save_file()


func get_currency():
	return save_data["meta_upgrade_currency"]


func get_upgrades():
	return save_data["meta_upgrades"]


func get_upgrade(upgrade_id: String):
	if save_data["meta_upgrades"].has(upgrade_id):
		return save_data["meta_upgrades"][upgrade_id]


func get_upgrade_quantity(upgrade_id: String) -> int:
	if save_data["meta_upgrades"].has(upgrade_id) && save_data["meta_upgrades"][upgrade_id].has("quantity"):
		return save_data["meta_upgrades"][upgrade_id]["quantity"]
	return 0


func load_save_file():
	if !FileAccess.file_exists(SAVE_FILE_PATH):
		return
	
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	save_data = file.get_var()


func save():
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	file.store_var(save_data)


func add_meta_uprade(upgrade: MetaUpgrade):
	if !save_data["meta_upgrades"].has(upgrade.id):
		save_data["meta_upgrades"][upgrade.id] = meta_upgrade_initial_value
	
	save_data["meta_upgrades"][upgrade.id]["quantity"] += 1
	save_data["meta_upgrade_currency"] -= upgrade.get_cost()
	save()


func on_experience_gained(amount: float):
	save_data["meta_upgrade_currency"] += amount
	#save()


func on_victory():
	save_data["victory_count"] += 1
	save()


func on_defeat():
	save_data["defeat_count"] += 1
	save()

