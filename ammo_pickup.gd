extends Node2D

onready var area = $Area2D
onready var player = get_parent().get_parent().get_node("Player")
onready var player_area = player.get_node("Area2D")

func _process(delta):
	if area.overlaps_area(player_area):
		player.update_ammo(5)
		queue_free()
