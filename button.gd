extends Button

func _ready() -> void:
	self.pressed.connect(_launch_scene)

func _launch_scene():
	if self.text == "Listen":
		get_tree().change_scene_to_file("res://listen.tscn")
		print("Launched Listen")
	elif self.text == "Create":
		get_tree().change_scene_to_file("res://create.tscn")
		print("Launched Create")