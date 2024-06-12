class_name MetaUpgrade extends Resource

@export var id: String
@export var max_level: int = 1
@export_range(0, 100, 5, "or_greater", "or_less") var value: float = 0
@export var experience_cost: int = 10
@export var icon_path: String
@export var name: String
@export_multiline var description: String

