extends TileMap

enum CellType { EMPTY = -1, ACTOR, OBSTACLE, OBJECT }
onready var Floor = get_node("Floor")

func _ready():
	for child in get_children():
		if child.name != "Floor":
			set_cellv(world_to_map(child.position), child.type)


func get_cell_pawn(coordinates):
	for node in get_children():
		if world_to_map(node.position) == coordinates:
			return(node)

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
