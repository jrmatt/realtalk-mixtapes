class_name FreqStation
extends AudioStreamPlayer

var position_in_dial: float
var has_been_discovered := false

var freq: Frequency
var current_index = -1
var current_track_time = 0.0
var current_track: Track
@onready var tracks = freq.tracks
var bar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("I'm playing: ", freq.frequency_name)
	tracks.shuffle()
	finished.connect(_play_next_track)
	
	_play_next_track()
	

func _play_next_track() -> void:
	current_track_time = 0.0
	current_index = (current_index + 1) % tracks.size()
	stream = tracks[current_index].audio
	current_track = tracks[current_index]
	
	play()
	
	
func _process(delta: float) -> void:
	current_track_time += delta
