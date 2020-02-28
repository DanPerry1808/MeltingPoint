extends Button

signal continue_playing

func _pressed():
	
	emit_signal('continue_playing')
