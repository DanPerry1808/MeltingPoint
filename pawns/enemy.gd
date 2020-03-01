extends "res://pawns/actor.gd"

# variables used in pathfinding:
# uncomment to get diagonal movement
var dirs = [
	Vector2(-1, 0),
	#Vector2(-1, -1),
	Vector2(0, -1),
	#Vector2(1, -1),
	Vector2(1, 0),
	#Vector2(1, 1),
	Vector2(0, 1),
	#Vector2(-1, 1)
]
onready var bounding_rect = grid.get_used_rect()
onready var player = get_node('../Player')

var counter = 0

# number of moves per second
var speed = 2

func _ready():
	Bullet = preload("res://Objects/EnemyBullet.tscn")

func Node(pos, end, parent=null, cost=0):
	return {
		'pos': pos,
		'parent': parent,
		'cost': cost,
		'est_to_end': pos.distance_to(end)
	}
	
	
func convert_to_grid_pos(pos):
	return pos / 64 - bounding_rect.position - Vector2(.5, .5)


	
func list_contains_pos(l, pos):
	for item in l:
		if item['pos'] == pos:
			return item
	return false


func insert_into_sorted(l, item):
	var i = 0
	while i < len(l) and l[i]['cost'] + l[i]['est_to_end'] < item['cost'] + item['est_to_end']:
		i += 1
	l.insert(i, item)
	
	
func get_map(end=false):
	var cells = grid.get_used_cells()
	var map = []
	for y in range(0, bounding_rect.size.y):
		map.append([])
		for x in range(0, bounding_rect.size.x):
			map[y].append(0)
			
	for cell in cells:
		if cell != end + bounding_rect.position:
			map[cell.y - bounding_rect.position.y][cell.x - bounding_rect.position.x] = 1
		else:
			map[cell.y - bounding_rect.position.y][cell.x - bounding_rect.position.x] = -1
	return map
	
	
func find_path(point, already_grid=false):
	
	var end
	if already_grid:
		end = point
	else:
		end = convert_to_grid_pos(point)

	var map = get_map(end)

	var visited = []
	var start = convert_to_grid_pos(get_position())
	var current = Node(start, end)
	var to_visit = [current]
	
	map[start.y][start.x] = -2
	
	while current['pos'] != end:
		for dir in dirs:
			var new_pos = current['pos'] + dir
			if map[new_pos.y][new_pos.x] <= 0:
				var node = list_contains_pos(visited, new_pos)
				if !node:
					node = list_contains_pos(to_visit, new_pos)
					if node:
						if node['cost'] > current['cost'] + 1:
							insert_into_sorted(to_visit, Node(new_pos, end, current['pos'], current['cost'] + 1))

					else:
						insert_into_sorted(to_visit, Node(new_pos, end, current['pos'], current['cost'] + 1))

		visited.append(current)
		var i = 0
		while i < len(to_visit):
			if to_visit[i]['pos'] == current['pos']:
				to_visit.remove(i)
				break
			i += 1
				
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
	
	return path
		
		
func get_input_direction():
	counter += 1
	if counter % int(60 / speed) == 0:
		return behaviour()
	else:
		return false


# returns a Vector2 like (1, 0) or (0, -1)	
func behaviour():
	var path = find_path(player.get_position())
	var direction = path[1]['pos'] - path[0]['pos']
	return direction
	
	
func on_hit(shooter, enemy):
	sfx['hit'].play()
	shooter.change_temp(-25)
	die()
	#grid.kill_pawn(self)
