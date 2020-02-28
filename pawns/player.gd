extends "res://pawns/actor.gd"

export(int) var temp = 0
export(int) var max_temp = 100

var dead: bool = false

signal died

func get_input_direction():
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)

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
