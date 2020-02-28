extends Node2D

signal you_died

export(PackedScene) var PlayerScene
export(int) var InvincibleTime = 3
export(int) var PlayerStartingLives = 3
var PlayerLives = 3

var player

var invincibleTimer

var playerCollision
var playerSprite
var playerWeapon

func _on_Play_Button_pressed():
	
	PlayerLives = PlayerStartingLives
	
	startGame()


func startGame():
	
	spawnPlayer(false)
	
	Global.hudLives.set_text(str(PlayerLives))


func spawnPlayer(isRespawn):
	
	player = PlayerScene.instance()
	
	player.playerSpawner = self
	
	add_child(player)
	
	if isRespawn:
	
		invincibleTimer = Global.oneShotTimer(InvincibleTime, self, player, "onInvincibleTimerStopped")
		
		playerCollision = player.get_node("CollisionShape2D")
		playerCollision.disabled = true
		
		playerSprite = player.get_node("player_anim")
		playerSprite.set_modulate(Color(1, 1, 1, 0.25))
		
		invincibleTimer.start()
	
		player.canMove = true
		player.canFire = false
	
	else:
		
		player.canMove = true


func playerDied():
	
	player.queue_free()
	
	emit_signal('you_died')


func onInvincibleTimerStopped():
	
	playerCollision.disabled = false
	player.canFire = true
	playerSprite.set_modulate(Color(1, 1, 1, 1))
