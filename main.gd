extends Node2D

var effect
var recording

var current_tape: Mixtape #the tape that was loaded (empty or recorded)
var recordings = []
var num_empty_tapes := 5
var playback_position
var gear_rotation_direction = 1
var gear_rotation_speed = 2
var btn_move_speed := 0.1
var btn_move_amt = 16

# Bit hacky, the labels get their text from signals from Dial
var current_track_speakers:
    get:
        return $Radio/RadioLabel/SpeakerLabel.text
var current_freq:
    get:
        return $Radio/RadioLabel/FrequencyLabel.text

const SaveScene = preload("res://save.tscn")
const MixtapeScene = preload("res://mixtape.tscn")


func _ready() -> void:
    # Get the index of the Master bus
    var idx = AudioServer.get_bus_index("Master")
    # Retrieve its effect
    effect = AudioServer.get_bus_effect(idx, 0)
    effect.set_recording_active(false)   
    
    # Create the stack of empty tapes
    for i in range(num_empty_tapes):
        _create_empty_tape()
    
    $Stacks/EmptyTapes.get_child(1).grab_focus()        
 

func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventJoypadMotion and not get_viewport().gui_get_focus_owner():
        $Stacks/EmptyTapes.get_child(1).grab_focus()
        
        
func btn_down(btn) -> void:
    var tween = create_tween()
    tween.tween_property(btn, "position", Vector2(0, btn_move_amt), btn_move_speed).as_relative()
    

func btn_half_down(btn) -> void:
    var tween = create_tween()
    tween.tween_property(btn, "position", Vector2(0, (btn_move_amt*.5)), btn_move_speed).as_relative()
    

func btn_up(btn) -> void:
    var tween = create_tween()
    tween.tween_property(btn, "position", Vector2(0, -btn_move_amt), btn_move_speed).as_relative()
    
    
func btn_half_up(btn) -> void:
    var tween = create_tween()
    tween.tween_property(btn, "position", Vector2(0, -(btn_move_amt*.5)), btn_move_speed).as_relative()
     
           
# --------
# BUTTON LISTENERS
# --------


func _on_record_btn_pressed() -> void:
    print("Record button pressed")
    if current_tape and current_tape.is_recordable:
        btn_down($Radio/RecordBtn)
        _start_recording()
    else:
        $Messages.text = "Load an Empty Tape to Record!"
        await get_tree().create_timer(2.0).timeout
        $Messages.text = ""

func _on_stop_btn_pressed() -> void:
    if not current_tape:
        print("No current tape")
        return
        
    if current_tape.player.playing:
        print("Player is playing, pausing")
        current_tape.player.stream_paused = true
        btn_half_down($Radio/StopBtn)
        btn_up($Radio/PlayBtn)
    elif not current_tape.is_recordable:
        print("Player is not playing, ejecting")
        btn_half_down($Radio/StopBtn)
        $Radio.remove_child(current_tape)
        $Stacks/RecordedTapes.add_child(current_tape)
        $Radio/TapeDoor.load_tape()
        current_tape.visible = true
        current_tape = null
        $Tape.visible = false
        $Radio/RadioLabel/TapeLabel.text = ""
        $Radio/Dial.cassette_mode = false
        $Radio/Dial.set_volumes()
        await get_tree().create_timer(1.5).timeout
        btn_up($Radio/StopBtn)
    elif effect.is_recording_active():
        btn_half_down($Radio/StopBtn)
        btn_up($Radio/RecordBtn)
        print("Stopping recording")
        effect.set_recording_active(false)
        _pause_recording()
    else:
        if current_tape.is_recordable and recordings.size() > 0:
            # launch the save scene
            var new_save = SaveScene.instantiate()
            btn_half_down($Radio/StopBtn)
            add_child(new_save)
            $Save/SaveBtn.pressed.connect(_save_tape)
            $Save/DiscardBtn.pressed.connect(_discard_tape)
            $Save/SaveBtn.grab_focus()
            print("Kicking off a new save scene: ", new_save)
            $Radio/TapeDoor.open_door()
        else:
            _create_empty_tape()
            current_tape = null
            $Tape.visible = false


func _on_play_btn_pressed() -> void:
    if not current_tape:
        print("No tape to play")
    elif not current_tape.is_recordable:
        if not current_tape.player.playing:
            print("Player is not playing")
            if not current_tape.player.stream_paused:
                print("Playing audio")
                btn_down($Radio/PlayBtn)
                current_tape.play_next_audio()
                print("Current tape index: ", current_tape.current_index)
            else:
                print("Unpausing")
                btn_down($Radio/PlayBtn)
                btn_half_up($Radio/StopBtn)
                current_tape.player.stream_paused = false
 

# --------
# TAPE CONTROLS
# --------    


func _create_empty_tape() -> void:
    var empty_tape = MixtapeScene.instantiate()
    empty_tape.is_recordable = true
    empty_tape.load_tape.connect(_on_tape_loaded)  
    $Stacks/EmptyTapes.add_child(empty_tape)
    print("Created tape: ", empty_tape)
     
    
func _save_tape() -> void:
    print("Trying to save current tape: ", current_tape)
    var saved_tape = MixtapeScene.instantiate()
    $Stacks/RecordedTapes.add_child(saved_tape)
    saved_tape.is_recordable = false
    saved_tape.load_tape.connect(_on_tape_loaded)
    print("Recordings to save: ", recordings)
    saved_tape.recording = recordings
    print("Saved current tape: ", saved_tape.recording)
    current_tape = null
    $Tape.visible = false
    recordings = []
    $Save.queue_free()
    $Radio/TapeDoor.close_door()
    btn_up($Radio/StopBtn)


func _discard_tape() -> void:
    current_tape.queue_free()
    $Save.queue_free()
    $Radio/TapeDoor.close_door()
    current_tape = null
    recordings = []
    $Tape.visible = false

               
func _on_tape_loaded(tape):
    if not current_tape:
        current_tape = tape
        $Tape.visible = true
        $Radio/TapeDoor.load_tape()
        if current_tape.is_recordable:
            print("Loading empty tape: ", current_tape, current_tape.is_recordable)
            $Stacks/EmptyTapes.remove_child(current_tape)
        else:
            print("Loading recorded tape: ", current_tape, current_tape.is_recordable)
            $Radio/Dial.mute()
            $Radio/Dial.cassette_mode = true
            $Stacks/RecordedTapes.remove_child(current_tape)
            $Radio.add_child(current_tape)
            current_tape.visible = false
            $Radio/RadioLabel/FrequencyLabel.text = ""
            $Radio/RadioLabel/SpeakerLabel.text = ""
            $Radio/RadioLabel/TapeLabel.text = "Tape " + str(current_tape.tape_id)     


# --------
# RECORDING CONTROLS
# --------


func _start_recording() -> void:
    effect.set_recording_active(true)
    print("Now recording")
       

func _pause_recording() -> void:
    recording = effect.get_recording()
    effect.set_recording_active(false)
    
    var recording_dict = {}
    if current_track_speakers:
        recording_dict.freq = current_freq
        recording_dict.speakers = current_track_speakers
        recording_dict.audio = recording
        recordings.append(recording_dict)
        print("Added recording with track info to tape: ", recordings)
    else:
        recording_dict.audio = recording
        recordings.append(recording_dict)
        print("Added recording to tape: ", recordings)
        
        
func _process(delta: float) -> void:
    if current_tape and (current_tape.player.playing or effect.is_recording_active()):
        $Tape/Gear1.rotation += gear_rotation_direction * gear_rotation_speed * delta
        $Tape/Gear2.rotation += gear_rotation_direction * gear_rotation_speed * delta
    print(get_viewport().gui_get_focus_owner())
     
