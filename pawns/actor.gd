extends "pawn.gd"

export(int) var temp = 0
export(int) var max_temp = 100

var dead: bool = false

signal died

onready var grid = get_parent()

func _ready():
	update_look_direction(Vector2.RIGHT)


func _process(_delta):
	var input_direction = get_input_direction()
	if not input_direction:
		return
	update_look_direction(input_direction)

	var target_position = grid.request_move(self, input_direction)
	if target_position:
		move_to(target_position)
	else:
		bump()


func get_input_direction():
	return false


func update_look_direction(direction):
	$Pivot/Sprite.rotation = direction.angle()


func move_to(target_position):
	set_process(false)
	$AnimationPlayer.play("walk")

	# Move the node to the target cell instantly,
	# and animate the sprite moving from the start to the target cell
	var move_direction = (target_position - position).normalized()
	$Tween.interpolate_property($Pivot, "position", - move_direction * 32, Vector2(), $AnimationPlayer.current_animation_length, Tween.TRANS_LINEAR, Tween.EASE_IN)
	position = target_position

	$Tween.start()

	# Stop the function execution until the animation finished
	yield($AnimationPlayer, "animation_finished")
	
	set_process(true)


func bump():
	set_process(false)
	$AnimationPlayer.play("bump")
	yield($AnimationPlayer, "animation_finished")
	set_process(true)

# Changes the player's temperature by the given amount
func change_temp(delta):
	temp += delta
	# Must check if player is dead after changing temp
	check_dead()

# Checks if the player has died, called on damage taken
func check_dead():
	if temp >= max_temp:
		dead = true
		emit_signal("died")
		
