class_name BatEnemy extends BasicEnemy


func move():
	velocity_component.accelerate_to_player()
	velocity_component.move(self)

