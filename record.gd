extends Button


func _on_recorder_started_recording() -> void:
	self.text = "Recording"


func _on_recorder_stopped_recording() -> void:
	self.text = "Record"
