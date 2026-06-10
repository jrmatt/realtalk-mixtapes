class_name Mixtape
extends Button

var recording = []
var is_recordable: bool
var current_index := -1
var tape_name: String

@onready var player := $PlayMix

signal load_tape(tape)
signal tape_ended


func _ready() -> void:
    pressed.connect(_on_button_pressed)

    if not is_recordable:
        $Label.text = tape_name
        
    player.finished.connect(play_next_audio)
    

func play_next_audio() -> void:
    if current_index < recording.size() - 1:
        current_index += 1
        player.stream = recording[current_index].audio
        
        player.play()

    else:
        current_index = -1
        tape_ended.emit()


func _on_button_pressed():
    load_tape.emit(self)
