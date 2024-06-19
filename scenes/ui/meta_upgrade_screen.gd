extends CanvasLayer

@export var upgrades: Array[MetaUpgrade] = []

@onready var grid_container = %GridContainer

var meta_upgrade_card_scene = preload("res://scenes/ui/meta_upgrade_card.tscn")


func _ready():
	for child in grid_container.get_children():
		child.queue_free()
	
	%BackButton.pressed.connect(on_back_button_pressed)
	for upgrade: MetaUpgrade in upgrades:
		var meta_upgrade_card_instance = meta_upgrade_card_scene.instantiate()
		grid_container.add_child(meta_upgrade_card_instance)
		meta_upgrade_card_instance.set_meta_upgrade(upgrade)


func on_back_button_pressed():
	ScreenTransition.transition_to_scene("res://scenes/ui/main_menu.tscn")

