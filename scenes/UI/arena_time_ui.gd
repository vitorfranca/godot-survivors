extends CanvasLayer

@export var arena_time_manager: ArenaTimeManager

func _process(_delta):
	if arena_time_manager == null:
		return
	
	var time_elapsed: float = arena_time_manager.get_time_elapsed()
	%Label.text = format_time(time_elapsed)
	

func format_time(time_elapsed: float) -> String:
	var minutes = floor(time_elapsed / 60)
	var seconds = time_elapsed - (minutes * 60)

	return "%02d:%02d" % [minutes, seconds]
	#return "%02d:%05.2f" % [minutes, seconds]
