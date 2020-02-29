extends StaticBody2D

var open: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func open():
	open = true
	$AnimatedSprite.play("open")
	$CollisionShape2D.disabled = true
	
func close():
	open = false
	$AnimatedSprite.play("close")
	$CollisionShape2D.disabled = false


func _on_Button_pressed_on():
	open()


func _on_Button_pressed_off():
	close()
