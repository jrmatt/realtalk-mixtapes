class_name Dial
extends Panel

@onready var bar: Panel = $Bar
@onready var static_player: AudioStreamPlayer = $Static
@onready var rewind: AudioStreamPlayer2D = $Rewind

signal playing_track(new_track)
signal playing_freq(new_freq)

signal start_rewind
signal stop_rewind

const BarScene = preload("res://bar.tscn")

var cassette_mode: bool

var frequencies = load("res://resources/frequencies.tres")
var freq_names = frequencies.frequency_names

var stations = []

var music_freq = 0.3

var last_position_was_valid := false 

var last_angle := 0.

var rewind_started_at := 0.0
const REWIND_MULTIPLE := 2.0

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
    bar_position = 0.3

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
        var color = Color(randf(), randf(), randf(), 0.01)
        station_bar.get_theme_stylebox('panel').bg_color = color
        station.bar = station_bar
        var label = station_bar.get_node('Label') as Label
        label.text = station.freq.frequency_name
        label.add_theme_color_override('font_color', color)
        
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
            tween.tween_property(current_station.bar.get_node('Label'), 'theme_override_colors/font_color:a', 1, 1)

        playing_freq.emit(current_station.freq.frequency_name)
        playing_track.emit(current_station.current_track)
    else:
        playing_freq.emit(null)
        playing_track.emit(null)


func get_stick_vector():
    if not cassette_mode:
        return Input.get_vector('wheel_left', 'wheel_right', 'wheel_up', 'wheel_down')


func stick_is_active():
    if not cassette_mode:
        return get_stick_vector().length() >= 0.99


func stick_angle():
    if not cassette_mode:
        return get_stick_vector().angle()


func get_current_station_for_label():
    var current_station = null

    for station in stations:
        if bar_distance_from_station(station) < 0.5:
            current_station = station

    return current_station

func _unhandled_input(event: InputEvent) -> void:
    if not cassette_mode:
        if event.is_action_pressed('rewind_time'):
            rewind_started_at = Time.get_ticks_msec()

            for station in stations:
                station.stream_paused = true

            static_player.stream_paused = true

            rewind.play()

            start_rewind.emit()

        elif event.is_action_released('rewind_time'):
            rewind.stop()

            var rewind_duration = (Time.get_ticks_msec() - rewind_started_at) / 1000 * REWIND_MULTIPLE
            print(rewind_duration)

            for station in stations:
                station.stream_paused = false

                station.seek(max(station.get_playback_position() - rewind_duration, 0))

            static_player.stream_paused = false
            static_player.seek(max(static_player.get_playback_position() - rewind_duration, 0))

            stop_rewind.emit()
        

func mute() -> void:
    for station in stations:
        station.volume_linear = 0
    static_player.volume_linear = 0

        
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
