extends TileMap

enum CellType { EMPTY = -1, ACTOR, OBSTACLE, OBJECT }
onready var Floor = get_node("Floor")
onready var player = get_node("Player")

func _ready():
	player.connect("died", self, "death_process")
	for child in get_children():
		if child.name != "Floor" and child.name != "BulletContainer" and child.name != "EndGamePanel":
			set_cellv(world_to_map(child.position), child.type)

func get_cell_pawn(coordinates):
	for node in get_children():
		if world_to_map(node.position) == coordinates:
			return(node)

func death_process():
	get_node("EndGamePanel").show()
	print("waiting for restart timer")
	get_tree().paused = true
	get_node("Player").death_timer.start()

func request_move(pawn, direction):
	
	if !pawn.dead:
		var cell_start = world_to_map(pawn.position)
		var cell_target = cell_start + direction
		var floor_target = Floor.get_cellv(cell_target)
		var cell_target_type = get_cellv(cell_target)
		match cell_target_type:
			CellType.EMPTY:
				if(pawn.name == "Player"):
					match floor_target:
						1:
							pawn.onHot = false
							pawn.onCold = true
						2:
							pawn.onCold = false
							pawn.onHot = true
						_:
							pawn.onHot = false
							pawn.onCold = false
				return update_pawn_position(pawn, cell_start, cell_target)
			CellType.OBJECT:
				var object_pawn = get_cell_pawn(cell_target)
				object_pawn.queue_free()
				return update_pawn_position(pawn, cell_start, cell_target)
			CellType.ACTOR:
				var pawn_name = get_cell_pawn(cell_target).name
				if pawn_name == "Player":
					var player = get_cell_pawn(cell_target)
					player.change_temp(5)
				print("Cell %s contains %s" % [cell_target, pawn_name])


func update_pawn_position(pawn, cell_start, cell_target):
	set_cellv(cell_target, pawn.type)
	set_cellv(cell_start, CellType.EMPTY)
	return map_to_world(cell_target) + cell_size / 2
	
	
func kill_pawn(node):
	var cell = world_to_map(node.get_position())
	set_cellv(cell, CellType.EMPTY)
	node.queue_free()
