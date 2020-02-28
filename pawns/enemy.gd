extends "res://pawns/actor.gd"

var dirs = [
	Vector2(-1, 0),
	Vector2(-1, -1),
	Vector2(0, -1),
	Vector2(1, -1),
	Vector2(1, 0),
	Vector2(1, 1),
	Vector2(0, 1),
	Vector2(-1, 1)
]

func Node(pos, parent=null, cost=0):
	return {
		'pos': pos,
		'parent': parent,
		'cost': cost
	}
	
func list_contains_pos(l, pos):
	for item in l:
		if item['pos'] == pos:
			return item
	return false

func get_input_direction():

	var grid = get_parent()
	var bounding_rect = grid.get_used_rect()
	var cells = grid.get_used_cells()
	
	var player = get_node('../Player')
	var player_pos = player.get_position() / 64 - bounding_rect.position + Vector2(.5, .5)
	
	var map = []
	for y in range(0, bounding_rect.size.y):
		map.append([])
		for x in range(0, bounding_rect.size.x):
			map[y].append(0)
			
	for cell in cells:
		if cell != player.get_position() / 64 + Vector2(.5, .5):
			map[cell.y - bounding_rect.position.y][cell.x - bounding_rect.position.x] = 1
		
	var visited = []
	var start = get_position() / 64 - bounding_rect.position + Vector2(.5, .5)
	var end = player_pos
	var current = Node(start)
	var to_visit = [current]
	
	while current['pos'] != end:
		for dir in dirs:
			var new_pos = current['pos'] + dir
			if map[new_pos.y][new_pos.x] == 0:
				var node = list_contains_pos(visited, new_pos)
				if node:
					if node['cost'] > current['cost'] + 1:
						to_visit.append(Node(new_pos, current['pos'], current['cost'] + 1))
				else:
					to_visit.append(Node(new_pos, current['pos'], current['cost'] + 1))
		
		visited.append(current)
		to_visit.remove(0)
		if len(to_visit) > 0:
			current = to_visit[0]
		else:
			break
	
	var path = []
	path.append(current)
	while true:
		var parent
		if !path[0]['parent']:
			break
		else:
			parent = list_contains_pos(visited, path[0]['parent'])
		path.insert(0, parent)
	
	var direction = path[1]['pos'] - path[0]['pos']
	return direction
