class_name Mixtape
extends Control

var recording = []
var is_recordable: bool
var tape_id : int
var current_index := -1
signal load_tape(tape)
@onready var player := $PlayMix


func _ready() -> void:
    if not is_recordable:
        tape_id = randi_range(100, 999)
        while tape_id in [666, 420]:
            tape_id = randi_range(100, 999)
        $Label.text = "Tape " + str(tape_id)
        
    player.finished.connect(play_next_audio)
    

func play_next_audio() -> void:
    if current_index < recording.size() - 1:
        current_index += 1
        player.stream = recording[current_index].audio
        
        player.play()
    else:
        current_index = -1


func _on_load_btn_pressed() -> void:
    load_tape.emit(self)
