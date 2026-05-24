extends Panel

@onready var bar: Panel = $Bar
@onready var static_player: AudioStreamPlayer = $Static

signal playing_track(new_track)
signal playing_freq(new_freq)

const BarScene = preload("res://bar.tscn")

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

        bar.position.x = bar_position * size.x - bar.size.x / 2

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

        var station_bar = BarScene.instantiate()
        station_bar.position.x = size.x * station.position_in_dial - station_bar.size.x / 2
        station_bar.get_theme_stylebox('panel').bg_color = Color(randf(), randf(), randf(), 0.05)
        station.bar = station_bar
        add_child(station_bar)

        stations.append(station)

func bar_distance_from_station(station):
    ''' Returns distance from station in multiples of STATION_WIDTH, capped at 1. ''' 
    return clampf(abs(bar_position - station.position_in_dial), 0., STATION_WIDTH) / STATION_WIDTH
    

func set_volumes():
    var total_static_reduction := 0.

    for station in stations:
        var distance = bar_distance_from_station(station)
        var station_volume = 1 - distance
        station.volume_linear = station_volume
        total_static_reduction += station_volume

    static_player.volume_linear = clampf(1 - total_static_reduction, 0, 1)**2

    var current_station = get_current_station_for_label()

    if current_station:
        if not current_station.has_been_discovered:
            var tween = create_tween()
            tween.tween_property(current_station.bar.get_theme_stylebox('panel'), 'bg_color:a', 1, 1)

        playing_freq.emit(current_station.freq.frequency_name)
        playing_track.emit(current_station.current_track)
    else:
        playing_freq.emit(null)
        playing_track.emit(null)


func get_stick_vector():
    return Input.get_vector('wheel_left', 'wheel_right', 'wheel_up', 'wheel_down')


func stick_is_active():
    return get_stick_vector().length() >= 0.99


func stick_angle():
    return get_stick_vector().angle()


func get_current_station_for_label():
    var current_station = null

    for station in stations:
        if bar_distance_from_station(station) < 0.5:
            current_station = station

    return current_station

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed('rewind_time'):
        for station in stations:
            station.seek(max(station.get_playback_position() - 1, 0))

func _process(_delta: float) -> void:

    if stick_is_active():
        var current_angle = stick_angle()

        if last_position_was_valid:
            var angle_delta = angle_difference(last_angle, current_angle)

            bar_position += angle_delta / (2 * PI * SPINS_FOR_FULL_LENGTH)

        last_angle = current_angle

        last_position_was_valid = true

    else:
        last_position_was_valid = false
