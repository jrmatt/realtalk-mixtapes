extends Node

var effect
var recording
var current_mix: Mixtape
var current_track: Track
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
		current_mix._save_recording(recording, current_track)
	else:
		effect.set_recording_active(true)
		started_recording.emit()
		if not current_mix:
			current_mix = Mixtape.new()


func _on_dial_playing_track(new_track: Variant) -> void:
	current_track = new_track
