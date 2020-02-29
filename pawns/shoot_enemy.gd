extends "res://pawns/enemy.gd"

var distance = 6
var target = null
var path = null

var testing_rotations = false
var rot = 0

func _ready():
	speed = 1
	
func raycast(start, end):
	
	var map = get_map(end)
	
	var dist = int(start.distance_to(end))
	var delta = (end - start) / dist
	var cells = []
	for i in range(dist):
		cells.append(start + delta * i)
		
	cells.remove(0)
		
	var value
	for cell in cells:
		value = map[int(cell.y)][int(cell.x)]
		if value > 0:
			return true
	return false


func behaviour():
	
	var player_pos = convert_to_grid_pos(player.get_position())
	var pos = convert_to_grid_pos(get_position())
	
	if !target or target.distance_to(player_pos) < distance - 1 or target.distance_to(player_pos) > distance + 1 or len(path) < 2:
		var delta = (pos - player_pos).normalized().rotated(rot)
		target = player_pos + delta * distance
		path = find_path(Vector2(int(target.x), int(target.y)), true)
		if raycast(target, player_pos):
			testing_rotations = true
			if rot == 0:
				rot = .4
			elif abs(rot) > PI * 2:
				testing_rotations = false
				rot = 0
			else:
				rot -= rot * 2 + rot / abs(rot) * 0.8
		else:
			testing_rotations = false
			rot = 0
		if testing_rotations:
			counter = 0
	
	if pos.distance_to(player_pos) < distance + 1:
		if !raycast(player_pos, pos):
			# shoot the player
			var delta = (player_pos - pos).normalized()
			shoot(delta, self)
			return false
	
	if len(path) < 2:
		target = null
		return false
		
	var direction = path[1]['pos'] - path[0]['pos']
	path.remove(0)
	return direction
