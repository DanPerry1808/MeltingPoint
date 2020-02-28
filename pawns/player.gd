extends "res://pawns/actor.gd"

export(int) var temp = 0
export(int) var max_temp = 100

var onHot = false
var onCold = false
var heat_timer = null
var death_timer = Timer.new()

signal died
signal temp_update

func _ready():
	heat_timer = Timer.new()
	add_child(heat_timer)
	add_child(death_timer)
	heat_timer.connect("timeout", self, "_on_Timer_timeout")
	heat_timer.set_wait_time(0.1)
	heat_timer.set_one_shot(false)
	death_timer.connect("timeout", self, "_on_Death_timer_timeout")
	death_timer.set_wait_time(5)
	heat_timer.start()

func _on_Timer_timeout():
	if onHot:
		if(temp < max_temp):
			change_temp(1)
	if onCold:
		if(temp > 0):
			change_temp(-1)
			
func _on_Death_timer_timeout():
	print("Reloading")
	dead = false
	temp = 0
	get_tree().reload_current_scene()

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
		print("Dead")
		death_timer.start()
		emit_signal("died")
