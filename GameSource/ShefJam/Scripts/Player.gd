extends KinematicBody2D

export(int) var Speed = 400
export(PackedScene) var MissileScene
export(float) var MissileInterval = 0.3
export(NodePath) var Barrel

export(int) var RespawnInterval = 1
var respawnTimer

var moveDirection
var firingTimer
var fireFrom

var mousePosition
var aimPosition

var canFire = true

var missile

var playerSpawner

var canMove = false

var fireSound
var tookHitSound


func _ready():
	
	moveDirection = Vector2(0, 0)
	
	firingTimer = Global.oneShotTimer(MissileInterval, self, self, "onFiringTimerStopped")
	
	fireFrom = $player_anim/waist/weapon/fireFrom
	
	$player_anim/Anim_Walk.play("walk")
	
	fireSound = $fireSound
	tookHitSound = $tookHitSound


func _physics_process(delta):
	

	# This code takes the angle the mouse is aiming at and converts it to a number that
	# can represent a time in the player animation to jump to in order to
	# make the little dude look like he's pointing the rifle in the right direction
	
	# 0 is aiming to the right
	# 90 is aiming straight down - 0.0
	# 180 is aiming to the left - 0.3 in animation
	# 270 is aiming straight up - 0.6
	
	# > 90 && <= 270 is left facing
	# <= 90 && > 270 is right facing
	
	var rotation_degrees = fposmod($aim.rotation_degrees, 360)
	
	var animation_time_range = 1.2
	var animation_split_into_degrees = animation_time_range / 360
	
	# mouse look
	mousePosition = get_global_mouse_position()
	$aim.look_at(mousePosition)
	
	aimPosition = to_global($aim.position)
	
	# Using separate left and right animations so can clip the whole player to face one direction or the other
	# If you flip within the animation you have to avoid tweening between facing right and left as though the
	# little dude were being spun in place.
	
	# aiming left
	if mousePosition.x < aimPosition.x:
		$player_anim/Anim_Aim.set_current_animation('aiming_left')
		
	# aiming right
	else:
		$player_anim/Anim_Aim.set_current_animation('aiming_right')
	
	
	var rotation_to_anim_time = (rotation_degrees - 0) * animation_split_into_degrees
	
	rotation_to_anim_time = clamp(rotation_to_anim_time, 0.0, animation_time_range)
	
	$player_anim/Anim_Aim.seek(rotation_to_anim_time)
	
	if canMove:
	
		# Move and collide
		if Input.is_action_pressed("left"):
			moveDirection.x = -1
	
		elif Input.is_action_pressed("right"):
			moveDirection.x = 1
			
		else:
			moveDirection.x = 0
	
		if Input.is_action_pressed("up"):
			moveDirection.y = -1
			
		elif Input.is_action_pressed("down"):
			moveDirection.y = 1
			
		else:
			moveDirection.y = 0
		
		# Fire weapon
		if Input.is_action_pressed("fire"):
			
			firePressed()
		
		
		var collision = move_and_collide(moveDirection * Speed * delta)
		
		if collision && collision.collider.get_node('character').is_visible():
	
			hitByEnemy(collision.collider)
	
	
	if moveDirection.x == 0 && moveDirection.y == 0:
		$player_anim/Anim_Walk.play("rest")
	elif (not $player_anim/Anim_Walk.get_current_animation() == "walk"):
		$player_anim/Anim_Walk.play("walk")


func firePressed():
	
	if canFire:
	
		fireMissile()
		
		# Start the firing timer
		firingTimer.start()
	
		# Turn off the ability to fire until the firing interval time runs out
		canFire = false


func fireMissile():
	
	# slight variation of volume so it doesn't get too rhythmic
	
	randomize()
	var randomVolume = rand_range(-2, 0)
	
	fireSound.set_volume_db(randomVolume)
	
	fireSound.play()
	
	missile = MissileScene.instance()
	
	missile.position = fireFrom.get_global_position()
	
	missile.rotation = $aim.get_rotation()
	
	missile.add_to_group("missiles")
	
	get_tree().get_root().add_child(missile)


func onFiringTimerStopped():
	
	# Set canFire back to true so the next round can be shot
	canFire = true


func hitByEnemy(enemy):
	
	tookHitSound.play()
	
	canMove = false
	
	enemy.queue_free()
	
	$explosion.set_emitting(true)
	$player_anim.visible = false
	
	var playerCollision = get_node("CollisionShape2D")
	
	playerCollision.disabled = true
	
	playerSpawner.PlayerLives -= 1
	
	Global.hudLives.set_text(str(playerSpawner.PlayerLives))
	
	if playerSpawner.PlayerLives > 0:
	
		respawnTimer = Global.oneShotTimer(RespawnInterval, self, self, "respawnPlayer")
	
		respawnTimer.start()
	
	else:
	
		for missile in get_tree().get_nodes_in_group('missiles'):
			missile.queue_free()
		
		playerSpawner.playerDied()


func respawnPlayer():
	
	playerSpawner.spawnPlayer(true)
	
	canMove = true
	
	self.queue_free()
