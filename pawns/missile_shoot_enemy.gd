extends "res://pawns/shoot_enemy.gd"


func _ready():
	Bullet = preload("res://Objects/HomingEnemyBullet.tscn")
	distance = 8
	speed = .75
