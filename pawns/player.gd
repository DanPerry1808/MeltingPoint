extends "res://pawns/actor.gd"

export(int) var temp = 0
export(int) var max_temp = 100

export(int) var ammo = 10
export(int) var max_ammo = 99

var onHot = false
var onCold = false
var heat_timer = null
var death_timer = Timer.new()

onready var camera = get_parent().get_parent().get_node('Camera2D')
onready var bounding_rect = grid.get_used_rect()

signal died
signal temp_update
signal ammo_update
signal restart

func _ready():
	heat_timer = Timer.new()
	add_child(heat_timer)
	add_child(death_timer)
	death_timer.connect("timeout", self, "respawn_timeout")
	death_timer.pause_mode = PAUSE_MODE_PROCESS
	heat_timer.connect("timeout", self, "_on_Timer_timeout")
	heat_timer.set_wait_time(0.1)
	death_timer.set_wait_time(5)
	heat_timer.set_one_shot(false)
	heat_timer.start()
	Bullet = preload("res://Objects/PlayerBullet.tscn")
	camera.offset = get_position() - get_viewport().size / 2
	
func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var mouse_pos = event.position
		var player_pos = get_global_transform_with_canvas().origin
		var diff = (mouse_pos - player_pos).normalized()
		if event.button_index == BUTTON_LEFT and ammo >= 1:
			shoot(diff, self)
			update_ammo(-1)
		elif event.button_index == BUTTON_RIGHT and ammo >= 3:
			shoot(diff, self)
			shoot(diff.rotated(.2), self)
			shoot(diff.rotated(-.2), self)
			update_ammo(-3)
		elif event.button_index == BUTTON_MIDDLE and ammo >= 8:
			for theta in range(8):
				shoot(diff.rotated(theta * PI / 4), self)
			update_ammo(-8)

func _on_Timer_timeout():
	if onHot:
		change_temp(5)
	if onCold:
		change_temp(-1)

func respawn_timeout():
	print("restart")
	get_tree().reload_current_scene()
	get_tree().paused = false

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
	
func update_ammo(delta):
	ammo += delta
	emit_signal("ammo_update")
	
func check_dead():
	if temp >= max_temp:
		dead = true
		print("Dead")
		emit_signal("died")
		
func on_hit(shooter, damage):
	change_temp(damage)
	bump()

func on_move():
	var tween = camera.get_node("Tween")
	var end_pos = get_position() - get_viewport().size / 2
	tween.interpolate_property(camera, "offset", camera.offset, end_pos, 0.25, tween.TRANS_LINEAR, tween.EASE_OUT)
	tween.start()
