extends YSort

var SpawnInterval = 5

export(float) var SpawnIntervalMin = 1.00

export(float) var SpawnIntervalMax = 3.00

export(int) var increaseSpawnRateEvery = 10

export(float) var increaseSpawnsBy = 1.1

var EnemyScenes = [
	"res://Gameplay/Enemy1.tscn",
	"res://Gameplay/Enemy2.tscn",
	"res://Gameplay/Enemy3.tscn"
	]

var maxEnemyLevel = 3

var enemiesToSpawn

var enemy
var enemyScene

var randomMin
var randomMax
var randomAngle

var enemySpawnLocation

export(String, "up", "right", "down", "left", "any") var Direction = "any"

var spawnTimer

var increaseSpawnRateTimer


func _ready():
	
	for i in range(0, EnemyScenes.size()):
		
		EnemyScenes[i] = load(EnemyScenes[i])


func _on_PlayButton_pressed():
	
	startGame()
#	pass


func _on_PlayerSpawner_you_died():
	
	clearEnemies()


func clearEnemies():
	
	if get_child_count() > 0:
		
		for i in get_children():
			i.queue_free()


func startGame():
	
	increaseSpawnRateTimer = Global.repeatingTimer(increaseSpawnRateEvery, self, self, "onIncreaseSpawnRate")
	
	increaseSpawnRateTimer.stop()
	
	spawnEnemy()
	
	increaseSpawnRateTimer.start()


func spawnEnemy():
	
	spawnTimer = Global.oneShotTimer(SpawnInterval, self, self, "onSpawnTimer")
	
	spawnTimer.start()
	
	spawnEnemies(1, self, Direction)


func spawnEnemies(level, nodeForPosition, direction):
	
	# decide how many enemies to spawn depending on level, i.e. the number of times they've split
	# randomly select which enemies to use
	# set their size depending on level
	# set spawn position depending on level. i.e. at last enemy location of level 2 or higher
	
	match level:
		1:
			enemiesToSpawn = 1
			enemySpawnLocation = position
			enemyScene = EnemyScenes[0]
		2:
			enemiesToSpawn = 2
			enemySpawnLocation = nodeForPosition.get_position()
			enemyScene = EnemyScenes[1]
		3:
			enemiesToSpawn = 2
			enemySpawnLocation = nodeForPosition.get_position()
			enemyScene = EnemyScenes[2]
	
	match direction:
		
		"any":
			randomMin = 0
			randomMax = 360
		
		"up":
			randomMin = 180
			randomMax = 360
		
		"right":
			randomMin = 270
			randomMax = 450
		
		"down":
			randomMin = 0
			randomMax = 180
		
		"left":
			randomMin = 90
			randomMax = 270
	
	for i in enemiesToSpawn:
		
		enemy = enemyScene.instance()
		
		enemy.enemyLevel = level
		
		enemy.position = enemySpawnLocation
		
		enemy.add_to_group("enemies")
		
		randomize()
		
		randomAngle = rand_range(randomMin, randomMax)
		
		if randomAngle >= 90 && randomAngle <= 270:
			
			enemy.apply_scale(Vector2(-1,1))
		
		enemy.angle = Vector2( cos(randomAngle), sin(randomAngle) )
		
		enemy.spawnedBy = self
		
		get_parent().add_child(enemy)


func onSpawnTimer():
	
	spawnTimer.queue_free()
	
	SpawnInterval = rand_range(SpawnIntervalMin, SpawnIntervalMax)
	
	spawnEnemy()


func onIncreaseSpawnRate():
	
	SpawnIntervalMin /= increaseSpawnsBy
	SpawnIntervalMax /= increaseSpawnsBy
