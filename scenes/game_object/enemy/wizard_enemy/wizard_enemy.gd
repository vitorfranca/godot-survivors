extends BasicEnemy
class_name WizardEnemy

var is_moving = false


func set_is_moving(moving: bool):
	is_moving = moving


func move():
	if is_moving:
		velocity_component.accelerate_to_player()
	else:
		velocity_component.decelerate()
	velocity_component.move(self)
