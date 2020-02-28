extends Area2D

export(int) var Speed = 1000

var angle

func _ready():
	
	angle = Vector2( cos(rotation), sin(rotation) )


func _physics_process(delta):
	
	position += (angle * Speed) * delta


func _on_Missile_body_entered(enemy):
	
	enemy.missileHit()
	
	self.queue_free()
