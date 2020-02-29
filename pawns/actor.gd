extends "pawn.gd"

var dead: bool = false

onready var grid = get_parent()
onready var bullet_container = grid.get_node('BulletContainer')

var Bullet = preload("res://Objects/Bullet.tscn")

func _ready():
	update_look_direction(Vector2.RIGHT)


func _process(_delta):
	if dead:
		if !$Tween.is_active():
			grid.kill_pawn(self)
	else:
		var input_direction = get_input_direction()
		if not input_direction:
			return
		update_look_direction(input_direction)
	
		var target_position = grid.request_move(self, input_direction)
		if target_position:
			move_to(target_position)
		else:
			bump()


func get_input_direction():
	return false


func update_look_direction(direction):
	if !dead:
		$Pivot/Sprite.rotation = direction.angle()


func move_to(target_position):
	if !dead:
		set_process(false)
		$AnimationPlayer.play("walk")

	# Move the node to the target cell instantly,
	# and animate the sprite moving from the start to the target cell
		var move_direction = (target_position - position).normalized()
		$Tween.interpolate_property($Pivot, "position", - move_direction * 32, Vector2(), $AnimationPlayer.current_animation_length, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$Pivot.set_position(-move_direction * 32)
		position = target_position

		$Tween.start()

	# Stop the function execution until the animation finished
		yield($AnimationPlayer, "animation_finished")
	
		set_process(true)


func bump():
	if !dead:
		set_process(false)
		$AnimationPlayer.play("bump")
		yield($AnimationPlayer, "animation_finished")
		set_process(true)
		
		
func shoot(delta, shooter):
	if !dead:
		var bullet = Bullet.instance()
		bullet.init(delta, shooter, get_position())
		bullet_container.add_child(bullet)
	
# when hit by a bullet
func on_hit(shooter, damage):
	bump()
	

func on_move():
	pass
	

func die():
	if !dead:
		$Pivot/Sprite.set_scale(Vector2(1.4, 1.4))
		$Tween.interpolate_property($Pivot/Sprite, "scale", Vector2(1.4, 1.4), Vector2(0, 0), .3, $Tween.TRANS_CUBIC, $Tween.EASE_OUT)
		$Tween.start()
		dead = true
