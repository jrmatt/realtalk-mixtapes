extends Panel

@onready var bounds: Panel = $'.'
@onready var bar: Panel = $Bar
@onready var static_player: AudioStreamPlayer = $Static
@onready var music: AudioStreamPlayer = $Music

signal playing_track(new_track)
signal playing_freq(new_freq)

var frequencies = load("res://resources/frequencies.tres")
var freq_names = frequencies.frequency_names

var stations = []

var music_freq = 0.3

var last_position_was_valid := false 

var last_angle := 0.

const SPINS_FOR_FULL_LENGTH := 10.
const STATION_WIDTH := 0.02

var bar_position := 0.:
    set(new_position):
        if new_position < 0 or new_position > 100:
            Input.start_joy_vibration(0, 0.5, 0.5, 0.1)

        bar_position = clampf(new_position, 0, 1)
            
        set_volumes()

        bar.position.x = bar_position * bounds.size.x

func _ready() -> void:
    var freq_interval: float = 1. / (freq_names.size() + 1)

    for freq_i in freq_names.size():
        var freq = freq_names[freq_i]

        var frequency: Frequency = load("res://resources/frequencies/frequency_%s.tres" % freq)
        var station = FreqStation.new()
        station.freq = frequency
        station.position_in_dial = freq_interval * (freq_i + 1)
        station.volume_linear = 0
        add_child(station)

        stations.append(station)
    

func set_volumes():

    var total_static_reduction := 0.

    for station in stations:
        var distance_from_center = clampf(abs(bar_position - station.position_in_dial), 0., STATION_WIDTH) / STATION_WIDTH
        var station_volume = 1 - distance_from_center
        station.volume_linear = station_volume
        total_static_reduction += station_volume

    static_player.volume_linear = clampf(1 - total_static_reduction, 0, 1)


func get_stick_vector():
    return Input.get_vector('wheel_left', 'wheel_right', 'wheel_up', 'wheel_down')


func stick_is_active():
    return get_stick_vector().length() >= 0.99


func stick_angle():
    return get_stick_vector().angle()


func _unhandled_input(_event: InputEvent) -> void:
    if stick_is_active():
        var current_angle = stick_angle()

        if last_position_was_valid:
            var angle_delta = angle_difference(last_angle, current_angle)

            bar_position += angle_delta / (2 * PI * SPINS_FOR_FULL_LENGTH)

        last_angle = current_angle

        last_position_was_valid = true

    else:
        last_position_was_valid = false
        

func _check_distance(stations):
    for station in stations:
        var distance_from_center = clampf(abs(bar_position - station.position_in_dial), 0., STATION_WIDTH) / STATION_WIDTH
        if distance_from_center <= STATION_WIDTH:
            return station		
        

func _process(delta: float) -> void:
    var current_station = _check_distance(stations)
    if current_station:
        playing_freq.emit(current_station.freq.frequency_name)
        playing_track.emit(current_station.current_track)
    else:
        playing_freq.emit(null)
        playing_track.emit(null)
