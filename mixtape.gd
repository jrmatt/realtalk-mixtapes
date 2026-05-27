class_name Mixtape
extends Button

var recording = []
var is_recordable: bool
var tape_id : int
var current_index := -1
signal load_tape(tape)
@onready var player := $PlayMix


func _ready() -> void:
    pressed.connect(_on_button_pressed)
    if not is_recordable:
        tape_id = randi_range(100, 999)
        while tape_id in [666, 420]:
            tape_id = randi_range(100, 999)
        $Label.text = "Tape " + str(tape_id)
        print(get_index())
        
    player.finished.connect(play_next_audio)
    

func play_next_audio() -> void:
    if current_index < recording.size() - 1:
        current_index += 1
        player.stream = recording[current_index].audio
        
        player.play()
    else:
        current_index = -1


func _on_button_pressed():
    load_tape.emit(self)


func _process(delta: float) -> void:
    if Input.is_action_just_pressed("load_tape"):
       load_tape.emit(self) 
