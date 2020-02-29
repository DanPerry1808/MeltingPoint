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
	
	Bullet = preload("res://Objects/PlayerBullet.tscn")
	
func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var mouse_pos = event.position
		var player_pos = get_global_transform_with_canvas().origin
		var diff = (mouse_pos - player_pos).normalized()
		shoot(diff, self)

func _on_Timer_timeout():
	if onHot:
		change_temp(1)
	if onCold:
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

func change_temp(delta):
	emit_signal("temp_update", delta)
	temp += delta
	if temp > 100:
		temp = 100
	if temp < 0:
		temp = 0
	print(temp)
	check_dead()
	
func check_dead():
	if temp >= max_temp:
		dead = true
		print("Dead")
		death_timer.start()
		emit_signal("died")
		
func on_hit(shooter, damage):
	change_temp(damage)
	bump()
