extends "res://pawns/actor.gd"

export(int) var temp = 0
export(int) var max_temp = 100

var onHot = false
var onCold = false
var heat_timer = null
var dead: bool = false

signal died
signal temp_update

func _ready():
	heat_timer = Timer.new()
	add_child(heat_timer)
	heat_timer.connect("timeout", self, "_on_Timer_timeout")
	heat_timer.set_wait_time(0.1)
	heat_timer.set_one_shot(false)
	heat_timer.start()

func _on_Timer_timeout():
	if onHot:
		change_temp(1)
	if onCold:
		if(temp > 0):
			change_temp(-1)

func get_input_direction():
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)

# Changes the player's temperature by the given amount
func change_temp(delta):
	temp += delta
	emit_signal("temp_update", delta)
	print(temp)
	# Must check if player is dead after changing temp
	check_dead()

func check_dead():
	if temp >= max_temp:
		dead = true
		emit_signal("died")
