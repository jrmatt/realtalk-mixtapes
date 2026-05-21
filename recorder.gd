extends Node

var effect
var recording
signal started_recording()
signal stopped_recording()
signal new_recording(recording)


func _ready() -> void:
	# Get the index of the Master bus
	var idx = AudioServer.get_bus_index("Master")
	# Retrieve its effect
	effect = AudioServer.get_bus_effect(idx, 0)


func _on_record_btn_pressed() -> void:
	if effect.is_recording_active():
		recording = effect.get_recording()
		effect.set_recording_active(false)
		stopped_recording.emit()
	else:
		effect.set_recording_active(true)
		started_recording.emit()


func _on_playback_btn_pressed() -> void:
	print(recording)
	print(recording.format)
	var data = recording.get_data()
	print(data.size())
	new_recording.emit(recording)
	
