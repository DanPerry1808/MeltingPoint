extends Node2D

var delta
var speed = 400
var shooter

onready var grid = get_parent().get_parent()
onready var bounding_rect = grid.get_used_rect()
onready var area = $Area2D

func init(d, s, pos):
	delta = d
	shooter = s
	set_position(pos)

func convert_to_grid_pos(pos):
	return pos / 64
	
func check_collisions():
	#var pos = get_position()
	#set_position(pos - bounding_rect.position)
	#print(get_position() - bounding_rect.position)
	for node in grid.get_children():
		if node != shooter and "type" in node and node.type == 0:
			print(node.get_position())
			if node.get_node('Area2D').overlaps_area(area):
				#set_position(pos)
				return true
	#set_position(pos)
	
func _process(dt):
	set_position(get_position() + delta * speed * dt)
	var cell = grid.get_cellv(convert_to_grid_pos(get_position()))
	# if the bullet hit a wall
	if cell > 0:
		queue_free()
	else:
		var collided = check_collisions()
		if collided:
			queue_free()
		
