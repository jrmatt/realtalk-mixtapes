extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_dial_track_changed(new_track: Variant) -> void:
	var speaker_array = new_track.speakers
	var speakers = ", ".join(speaker_array)
	self.text = speakers
