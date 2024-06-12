class_name AbilityUpgrade
extends Resource

## id of the ability.[br]This is used internally.
@export var id: String

## How many times the player can upgrade this ability.[br]Starts at level 1.
@export var max_level: int = 0

## Used to calculate ability upgrade.[br]Should match the description.
@export_range(0, 100, 5, "or_greater", "or_less") var value: float = 0

## Will be displayed when the user chooses abilities.
@export var icon_path: String

## Will be displayed when the user chooses abilities.
@export var name: String

## Will be displayed when the user chooses abilities.
@export_multiline var description: String
