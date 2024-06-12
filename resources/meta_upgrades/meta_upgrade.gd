class_name MetaUpgrade extends Resource

@export var id: String
@export var max_quantity: int = 1
@export var title: String
@export_multiline var description: String
@export_range(0, 100, 5, "or_greater", "or_less") var value: float = 0


