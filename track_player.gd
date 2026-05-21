extends AudioStreamPlayer

var all_frequencies = load("res://resources/frequencies.tres")
var frequencies = all_frequencies.frequencies
var i = -1
signal current_freq(new_freq)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func _on_dial_pressed() -> void:
	var freqs = frequencies
	i = (i +1) % freqs.size()
	var new_freq = freqs[i]
	current_freq.emit(new_freq)
	print(new_freq)
	
		
	play()
	
	
func _filter_by_freq(tracks_to_filter, frequency):
	var freq_tracks: Array = []
	
	for track in tracks_to_filter:
		if frequency in track.frequencies:
			freq_tracks.append(track)
			
	return freq_tracks
