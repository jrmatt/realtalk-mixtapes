class_name Mixtape
extends Node2D

var recordings = []


func _save_recording(recording):
	recordings.append(recording)
	print(recordings)
