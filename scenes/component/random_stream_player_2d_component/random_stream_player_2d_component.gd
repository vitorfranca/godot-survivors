class_name RandomStreamPlayer2DComponent extends AudioStreamPlayer2D

@export var streams: Array[AudioStream]


func play_random():
	if streams == null || streams.is_empty():
		return
		
	var chosen_stream: AudioStream = streams.pick_random()
	stream = chosen_stream
	play()

