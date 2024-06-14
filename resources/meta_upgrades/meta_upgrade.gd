class_name MetaUpgrade extends Resource

@export var id: String
@export var max_level: int = 1
@export_range(0, 1, .05, "or_greater", "or_less") var value: float = 0
@export var experience_cost: int = 10
@export var icon_path: String
@export var name: String
@export_multiline var description: String


func get_quantity():
	return MetaProgression.get_upgrade_quantity(id)


func get_cost():
	var quantity = get_quantity()
	return (quantity + pow(2, min(4, quantity))) * (experience_cost * (quantity + 1))

