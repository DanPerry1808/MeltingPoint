extends "res://Objects/enemy_bullet.gd"

onready var player = get_parent().get_parent().get_node('Player')
var homing_amount = .05
var remove_timer = 8

func _ready():
	speed = 150
	
func _process(dt):
	remove_timer -= dt
	if remove_timer < 0:
		queue_free()

func move(dt):
	var player_pos = player.get_position()
	var diff = (player_pos - get_position()).normalized()
	delta = (delta + diff * homing_amount).normalized()
	set_position(get_position() + delta * speed * dt)
