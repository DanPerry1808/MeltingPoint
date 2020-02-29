extends StaticBody2D

var on: bool = false

signal pressed_on
signal pressed_off

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func turn_on():
	on = true
	$AnimatedSprite.play("on")
	
func turn_off():
	on = false
	$AnimatedSprite.play("off")


func _on_ToggleArea_area_entered(area):
	if on:
		turn_off()
		emit_signal("pressed_off")
	else:
		turn_on()
		emit_signal("pressed_on")
