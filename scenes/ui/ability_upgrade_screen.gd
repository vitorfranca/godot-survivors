extends CanvasLayer

signal upgrade_selected(upgrade: AbilityUpgrade)

@export var upgrade_card_scene: PackedScene

@onready var card_container: BoxContainer = %CardContainer
@onready var panel_container: PanelContainer = %PanelContainer


func _ready():
	get_tree().paused = true
	
	# TODO fix issue where pivot is to the top left of the panel container
	#panel_container.pivot_offset = panel_container.size / 2
	#var tween = create_tween()
	#tween.tween_property(panel_container, "scale", Vector2.ZERO, 0)
	#tween.tween_property(panel_container, "scale", Vector2.ONE, .3)\
		#.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)


func set_ability_upgrades(upgrades: Array[AbilityUpgrade]):
	var delay = 0
	for upgrade in upgrades:
		var card_instance = upgrade_card_scene.instantiate()
		card_container.add_child(card_instance)
		card_instance.set_ability_upgrade(upgrade)
		card_instance.play_in(delay)
		delay += 0.2
		card_instance.selected.connect(on_upgrade_selected.bind(upgrade))


func on_upgrade_selected(upgrade: AbilityUpgrade):
	panel_container.pivot_offset = panel_container.size / 2
	
	upgrade_selected.emit(upgrade)
	$AnimationPlayer.play("out")
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ONE, 0)
	tween.tween_property(panel_container, "scale", Vector2.ZERO, .3)\
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	
	await tween.finished
	get_tree().paused = false
	queue_free()

