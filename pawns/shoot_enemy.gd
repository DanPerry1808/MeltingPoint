extends "res://pawns/enemy.gd"

var distance = 6
var target = null
var path = null

	
func raycast(start, end):
	
	var map = get_map(end)
	
	var distance = int(start.distance_to(end))
	var delta = (end - start) / distance
	var cells = []
	for i in range(distance):
		cells.append(start + delta * i)
		
	cells.remove(0)
		
	var value
	for cell in cells:
		value = map[int(cell.y)][int(cell.x)]
		print(cell, value)
		if value > 0:
			return true
	return false


func behaviour():
	
	var player_pos = convert_to_grid_pos(player.get_position())
	var pos = convert_to_grid_pos(get_position())
	
	if !target or target.distance_to(player_pos) < distance - 1 or target.distance_to(player_pos) > distance + 1 or len(path) < 2:
		var ray_to_player = false
		var rot = 0
		while !ray_to_player:
			var delta = (pos - player_pos).normalized().rotated(rot)
			target = player_pos + delta * distance
			path = find_path(Vector2(int(target.x), int(target.y)), true)
			if raycast(target, player_pos):
				if rot == 0:
					rot = .4
				elif abs(rot) > PI * 2:
					break
				else:
					rot -= rot * 2 + rot / abs(rot) * 0.4
			else:
				ray_to_player = true
	
	if pos.distance_to(player_pos) < distance + 1:
		# shoot the player
		if !raycast(player_pos, pos):
			return false
	
	if len(path) < 2:
		target = null
		return false
		
	var direction = path[1]['pos'] - path[0]['pos']
	path.remove(0)
	return direction
