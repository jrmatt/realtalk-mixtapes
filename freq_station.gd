class_name FreqStation
extends AudioStreamPlayer

#var tracks: Array = []
var freq: Frequency
var current_index = -1
@onready var tracks = freq.tracks

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("I'm playing: ", freq.frequency_name)
	tracks.shuffle()
	finished.connect(_play_next_track)
	
	_play_next_track()
	

func _play_next_track() -> void:
	current_index = (current_index + 1) % tracks.size()
	
	stream = tracks[current_index].audio
	play()
