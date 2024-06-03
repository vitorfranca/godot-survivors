class_name BasicEnemy extends CharacterBody2D

@onready var visuals: Node2D = $Visuals
@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var hurtbox_component:HurtboxComponent = $HurtboxComponent


func _ready():
	hurtbox_component.hit.connect(on_hit)


func _process(_delta):
	move()
	turn_visuals()


func move():
	velocity_component.accelerate_to_player()
	velocity_component.move(self)
	

func turn_visuals():
	var move_sign = sign(velocity.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1)


func on_hit():
	$RandomStreamPlayer2DComponent.play_random()

