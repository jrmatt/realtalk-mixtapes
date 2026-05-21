extends Button

var frequencies = load("res://resources/frequencies.tres")
var freq_names = frequencies.frequency_names
var i = -1
signal current_freq(new_freq)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.pressed.connect(_button_pressed)
	
	for freq in freq_names:
		var frequency: Frequency = load("res://resources/frequencies/frequency_%s.tres" % freq)
		var station = FreqStation.new()
		station.freq = frequency
		add_child(station)


func _button_pressed():
	print("pressed")
	i += 1
	var new_freq_name = freq_names[i]
	print(new_freq_name)
	current_freq.emit(new_freq_name)
