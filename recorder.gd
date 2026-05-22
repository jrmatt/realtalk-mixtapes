extends Node

var effect
var recording
var current_mix: Mixtape
signal started_recording()
signal paused_recording()
signal new_recording(recording)
signal new_mix(current_mix)

func _ready() -> void:
	# Get the index of the Master bus
	var idx = AudioServer.get_bus_index("Master")
	# Retrieve its effect
	effect = AudioServer.get_bus_effect(idx, 0)


func _on_record_btn_pressed() -> void:
	if effect.is_recording_active():
		recording = effect.get_recording()
		effect.set_recording_active(false)
		paused_recording.emit()
		
		print("Recorded: ", recording)
		new_recording.emit(recording)
		current_mix._save_recording(recording)
	else:
		effect.set_recording_active(true)
		started_recording.emit()
		if not current_mix:
			current_mix = Mixtape.new()
	

func _get_current() -> void:
	get_parent()
