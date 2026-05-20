extends AudioStreamPlayer

var track_library = load("res://resources/library.tres")
var tracks = track_library.tracks
var all_frequencies = load("res://resources/frequencies.tres")
var frequencies = all_frequencies.frequencies
var i = -1
signal current_freq(new_freq)
var current_track = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func _on_dial_pressed() -> void:
	var freqs = frequencies
	i += 1
	var new_freq = freqs[i]
	current_freq.emit(new_freq)
	print(new_freq)
	
	var freq_tracks = _filter_by_freq(tracks, new_freq)
	print(freq_tracks)

	for track in freq_tracks:
		self.stream.add_stream(-1, track.audio, 1)
		
	play()
	
	
func _filter_by_freq(tracks_to_filter, frequency):
	var freq_tracks: Array = []
	
	for track in tracks_to_filter:
		if frequency in track.frequencies:
			freq_tracks.append(track)
			
	return freq_tracks
	
