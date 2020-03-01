extends "res://pawns/shoot_enemy.gd"


func _ready():
	hp = 15
	Bullet = preload("res://Objects/HomingEnemyBullet.tscn")
	distance = 8
	speed = .5
