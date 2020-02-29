extends "res://pawns/enemy.gd"

var distance = 5
var target = null
var path = null

func _ready():
	speed = 0.75

func behaviour():
	
	var player_pos = convert_to_grid_pos(player.get_position())
	var pos = convert_to_grid_pos(get_position())
	
	if !target or target.distance_to(player_pos) < distance - 1 or target.distance_to(player_pos) > distance + 1 or len(path) < 2:
		var delta = (pos - player_pos).normalized()
		target = player_pos + delta * distance
		path = find_path(Vector2(int(target.x), int(target.y)), true)
	
	if pos.distance_to(player_pos) > distance - 1 and pos.distance_to(player_pos) < distance + 1:
		return false
	
	var direction = path[1]['pos'] - path[0]['pos']
	path.remove(0)
	return direction
