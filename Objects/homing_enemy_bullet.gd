extends "res://Objects/enemy_bullet.gd"

onready var player = get_parent().get_parent().get_node('Player')
var homing_amount = .05

func _ready():
	speed = 200

func move(dt):
	var player_pos = player.get_position()
	var diff = (player_pos - get_position()).normalized()
	delta = (delta + diff * homing_amount).normalized()
	set_position(get_position() + delta * speed * dt)
