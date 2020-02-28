extends Sprite

var viewport

func _ready():
	
	set_visible(false)
	viewport = get_viewport()


func _process(_delta):
	
	self.position = get_global_mouse_position()


func _on_PlayButton_pressed():
	set_visible(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _on_PlayerSpawner_you_died():
	set_visible(false)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
