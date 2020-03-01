extends Area2D

export(String) var next_level

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_EndPoint_area_entered(area):
	if not next_level.empty():
		get_tree().change_scene(next_level)
	else:
		print("No next level selected")
