extends NinePatchRect

func _ready():
	var player = get_parent().get_parent().get_parent().get_parent().get_node("Grid").get_node("Player")
	get_node("Label").text = str(player.ammo)
	player.connect("ammo_update", self, "_on_ammo_update")
	pass

func _on_ammo_update():
	var player = get_parent().get_parent().get_parent().get_parent().get_node("Grid").get_node("Player")
	self.get_node("Label").text = str(player.ammo)
