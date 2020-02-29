extends HBoxContainer

func _ready():
	var player = get_parent().get_parent().get_node("Grid").get_node("Player")
	print(player.name)
	player.connect("temp_update", self, "_on_temp_update")
	pass

func _on_temp_update(temp):
	self.get_node("TextureProgress").value = temp
