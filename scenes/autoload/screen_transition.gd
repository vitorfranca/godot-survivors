extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect
@onready var animation_player = $AnimationPlayer

signal transition_half


func transition():
	animation_player.play("default")
	await animation_player.animation_finished


func emit_transition_half():
	transition_half.emit()

