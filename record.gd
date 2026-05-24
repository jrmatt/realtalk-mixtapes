extends Button


func _on_recorder_started_recording() -> void:
    self.text = "Recording"


func _on_recorder_paused_recording() -> void:
    self.text = "Record"
