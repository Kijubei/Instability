extends ProgressBar

signal charged

func _process(delta):
	value += step
	
	if value == max_value:
		value = 0
		emit_signal("charged")
