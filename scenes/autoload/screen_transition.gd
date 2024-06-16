extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect
@onready var animation_player = $AnimationPlayer

signal transition_half


func transition():
	animation_player.play("default")
	await animation_player.animation_finished


func transition_to_scene(path: String, _unpause: bool = true):
	# TODO Make transitions work
	#transition()
	#await transition_half
	#if unpause:
		#get_tree().paused = false
	get_tree().change_scene_to_file(path)


func emit_transition_half():
	transition_half.emit()

