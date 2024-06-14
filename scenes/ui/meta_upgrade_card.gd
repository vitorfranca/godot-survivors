extends PanelContainer

@onready var name_label = %NameLabel
@onready var description_label = %DescriptionLabel
@onready var ability_icon = %AbilityIcon
@onready var progress_bar = %ProgressBar
@onready var progress_label = %ProgressLabel
@onready var purchase_button = %PurchaseButton
@onready var count_label = %CountLabel
@onready var progress_container = %ProgressContainer

var upgrade: MetaUpgrade


func _ready():
	purchase_button.pressed.connect(on_purchase_pressed)


func set_meta_upgrade(upgrade: MetaUpgrade):
	self.upgrade = upgrade
	name_label.text = upgrade.name
	description_label.text = upgrade.description
	ability_icon.texture = load(upgrade.icon_path)
	update_progress()


func update_progress():
	var current_currency = MetaProgression.get_currency()
	var current_quantity = MetaProgression.get_upgrade_quantity(upgrade.id)
	var is_maxed = current_quantity >= upgrade.max_level
	var percent = current_currency / upgrade.get_cost()
	percent = min(percent, 1)
	progress_bar.value = percent
	progress_label.text = "%s/%s" % [current_currency, upgrade.get_cost()]
	#purchase_button.disabled = percent < 1 || is_maxed
	count_label.text = "x%d" % current_quantity
	
	if is_maxed:
		purchase_button.text = "Max"
		#progress_container.visible = false


func on_purchase_pressed():
	if upgrade == null:
		return
	
	MetaProgression.add_meta_uprade(upgrade)
	get_tree().call_group("meta_upgrade_card", "update_progress")
	$AnimationPlayer.play("selected")
