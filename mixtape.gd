class_name Mixtape
extends Node2D

var recordings = []


func _save_recording(recording, current_track):
	var recording_dict = {}
	if current_track:
		recording_dict.recording = recording
		recording_dict.freq = current_track.frequency
		recording_dict.speakers = current_track.speakers
	else:
		recording_dict.recording = recording
	recordings.append(recording_dict)
	print(recordings)
