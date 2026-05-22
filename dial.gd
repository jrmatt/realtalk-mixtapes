extends Button

var frequencies = load("res://resources/frequencies.tres")
var freq_names = frequencies.frequency_names
var current_index := -1
var current_freq: String = ""
signal playing_freq(new_freq)
signal playing_track(new_track)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.pressed.connect(_button_pressed)
	for freq in freq_names:
		var frequency: Frequency = load("res://resources/frequencies/frequency_%s.tres" % freq)
		var station = FreqStation.new()
		station.freq = frequency
		station.volume_db = -80.0
		add_child(station)


func _button_pressed():
	current_index = (current_index + 1) % freq_names.size()
	var new_freq_name = freq_names[current_index]
	current_freq = new_freq_name
	_change_station(current_freq)
	print("Dial sets new freq: ", new_freq_name)
	

func _change_station(freq):
	var stations = self.get_children()
	#playing_freq.emit(freq)
	for station in stations:
		station.volume_db = -80
		if station.freq.frequency_name == freq:
			station.volume_db = 0.0


func _on_recorder_new_mix(current_mix: Variant) -> void:
	var stations = self.get_children()
	for station in stations:
		station.volume_db = -80


func _process(delta: float) -> void:
	var stations = self.get_children()
	for station in stations:
		if station.freq.frequency_name == current_freq:
			playing_track.emit(station.current_track)
			playing_freq.emit(current_freq)
