extends Node2D

var effect
var recording

var loaded_tape: Mixtape #the tape that was loaded (empty or recorded)
var recordings = []
var num_empty_tapes := 5
var playback_position

var gear_rotation_direction = 1
var gear_rotation_speed = 2

var btn_move_duration := 0.1
var btn_move_amt = 16
var disabled_btn_move_amt = 2

var currently_accepting_button_presses := true
var showing_controls := false

var current_track_speakers := []
var current_freq: String

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
    if event.is_action_pressed('ui_left') or event.is_action_pressed('ui_right') or event.is_action_pressed('ui_up') or event.is_action_pressed('ui_down'):
        var current_focus = get_viewport().gui_get_focus_owner()
        if not current_focus:
            $Stacks/EmptyTapes.get_child(1).grab_focus()
    if event.is_action_pressed("show_controls"):
        if not currently_accepting_button_presses:
            return
        else:
            showing_controls = not showing_controls
            $Logo.visible = not $Logo.visible
            $Controls.visible = not $Controls.visible
        

func move_button_to_ys(btn, ys):
    var tween = create_tween()
    for y in ys:
        tween.tween_property(btn, "position:y", y, btn_move_duration)


func depress_button(btn):
    move_button_to_ys(btn, [btn_move_amt])


func pop_button(btn):
    move_button_to_ys(btn, [0])


func depress_and_pop_button(btn):
    move_button_to_ys(btn, [btn_move_amt, 0])
    

func depress_disabled_button(btn):
    move_button_to_ys(btn, [disabled_btn_move_amt, 0])


# --------
# BUTTON LISTENERS
# --------


func _on_record_btn_pressed() -> void:      
    if not currently_accepting_button_presses:
        return

    if loaded_tape and loaded_tape.is_recordable:
        depress_button($Radio/RecordAnchor/RecordBtn)
        depress_button($Radio/PlayAnchor/PlayBtn)
        _start_recording()
    else:
        depress_disabled_button($Radio/RecordAnchor/RecordBtn)
        depress_disabled_button($Radio/PlayAnchor/PlayBtn)
        $Messages.text = "Load an Empty Tape to Record!"
        await get_tree().create_timer(2.0).timeout
        $Messages.text = ""


func _on_stop_btn_pressed() -> void:

    if not currently_accepting_button_presses:
        return

    if not loaded_tape:
        depress_disabled_button($Radio/StopAnchor/StopBtn)
        print("No current tape")
        return
        
    if loaded_tape.player.playing:
        depress_and_pop_button($Radio/StopAnchor/StopBtn)
        print("Player is playing, pausing")
        loaded_tape.player.stream_paused = true

    elif not loaded_tape.is_recordable:
        depress_and_pop_button($Radio/StopAnchor/StopBtn)
        pop_button($Radio/PlayAnchor/PlayBtn)
        pop_button($Radio/RecordAnchor/RecordBtn)
        print("Player is not playing, ejecting")
        $Radio.remove_child(loaded_tape)
        $Stacks/RecordedTapes.add_child(loaded_tape)
        $Radio/TapeDoor.load_tape()
        loaded_tape.visible = true
        loaded_tape = null
        $Tape.visible = false
        $Radio/Control/TapeLabel.text = ""
        $Radio/TapeDoor.open_door()
        
        $Radio/Dial.cassette_mode = false
        $Radio/Dial.set_volumes_and_label()

    elif effect.is_recording_active():
        depress_and_pop_button($Radio/StopAnchor/StopBtn)
        pop_button($Radio/PlayAnchor/PlayBtn)
        pop_button($Radio/RecordAnchor/RecordBtn)
        print("Stopping recording")
        effect.set_recording_active(false)
        _pause_recording()

    else:
        if loaded_tape.is_recordable and recordings.size() > 0:
            $Radio/Dial.mute()
            $Radio/Dial.cassette_mode = true
            
            depress_and_pop_button($Radio/StopAnchor/StopBtn)
            pop_button($Radio/PlayAnchor/PlayBtn)
            pop_button($Radio/RecordAnchor/RecordBtn)
            var new_save = SaveScene.instantiate()
            currently_accepting_button_presses = false
            add_child(new_save)
            
            $Save/TextEditWithOnScreenKeyboard.on_submit_pressed.connect(_save_tape)
            $Save/TextEditWithOnScreenKeyboard.on_cancel_pressed.connect(_discard_tape)
            $Save/TextEditWithOnScreenKeyboard/MarginContainer/VBoxContainer/Controls/Keyboards/Qwerty/LettersBig/Q.grab_focus()
            
            $Radio/TapeDoor.open_door()

        else:
            depress_and_pop_button($Radio/StopAnchor/StopBtn)
            _create_empty_tape()
            $Radio/TapeDoor.open_door()
            loaded_tape = null
            $Tape.visible = false


func _on_play_btn_pressed() -> void:
    if not currently_accepting_button_presses:
        return

    if not loaded_tape:
        print("No tape to play")
        depress_disabled_button($Radio/PlayAnchor/PlayBtn)

    elif loaded_tape.is_recordable:
        depress_disabled_button($Radio/PlayAnchor/PlayBtn)
        
    else:
        depress_button($Radio/PlayAnchor/PlayBtn)
        
        if not loaded_tape.player.playing:
            depress_button($Radio/PlayAnchor/PlayBtn)
            print("Player is not playing")
            if not loaded_tape.player.stream_paused:
                depress_button($Radio/PlayAnchor/PlayBtn)
                print("Playing audio")
                loaded_tape.play_next_audio()
                print("Current tape index: ", loaded_tape.current_index)
            else:
                depress_button($Radio/PlayAnchor/PlayBtn)
                print("Unpausing")
                loaded_tape.player.stream_paused = false


# --------
# SIGNAL LISTENERS
# --------
 

func _on_dial_start_rewind() -> void:
    depress_button($Radio/RwAnchor/RwBtn)


func _on_dial_stop_rewind() -> void:
    pop_button($Radio/RwAnchor/RwBtn)
    

func _on_dial_playing_freq(new_freq: Variant, alpha: Variant) -> void:
    if new_freq:
        current_freq = new_freq


func _on_dial_playing_track(new_track: Variant, alpha: Variant) -> void:
    if new_track:
        current_track_speakers = new_track.speakers


# --------
# TAPE CONTROLS
# --------    


func _create_empty_tape() -> void:
    var empty_tape = MixtapeScene.instantiate()
    empty_tape.is_recordable = true
    empty_tape.load_tape.connect(_on_tape_loaded)  
    $Stacks/EmptyTapes.add_child(empty_tape)
     
    
func _save_tape(text) -> void:
    print("Trying to save current tape: ", loaded_tape)
    
    var saved_tape = MixtapeScene.instantiate()
    saved_tape.is_recordable = false
    saved_tape.recording = recordings
    
    var input_text = text
    var text_is_safe = _check_text_safety(text)

    if not input_text or not text_is_safe:
        var tape_id = -1

        while tape_id in [-1, 420, 666]:
            tape_id = randi_range(100, 999)

        input_text = "Tape: " + str(tape_id)

    saved_tape.tape_name = input_text
        
    $Stacks/RecordedTapes.add_child(saved_tape)
    saved_tape.load_tape.connect(_on_tape_loaded)
    
    print("Saved current tape: ", saved_tape.recording)
    
    loaded_tape = null
    $Tape.visible = false
    recordings = []
    $Save.queue_free()
    $Radio/Dial.cassette_mode = false
    
    $Radio/Dial.set_volumes_and_label()

    currently_accepting_button_presses = true


func _discard_tape() -> void:
    loaded_tape.queue_free()
    $Save.queue_free()
    loaded_tape = null
    recordings = []
    $Tape.visible = false

    $Radio/Dial.set_volumes_and_label()

    currently_accepting_button_presses = true

               
func _on_tape_loaded(tape):
    
    if not loaded_tape:
        loaded_tape = tape
        $Tape.visible = true
        $Radio/TapeDoor.load_tape()

        if loaded_tape.is_recordable:
            print("Loading empty tape: ", loaded_tape, loaded_tape.is_recordable)
            $Stacks/EmptyTapes.remove_child(loaded_tape)

        else:
            print("Loading recorded tape: ", loaded_tape, loaded_tape.is_recordable)
            $Stacks/RecordedTapes.remove_child(loaded_tape)
            $Radio.add_child(loaded_tape)
            loaded_tape.visible = false
            
            $Radio/RadioLabel/HBoxContainer/Label.freq_name = ""
            $Radio/RadioLabel/HBoxContainer/Label2.freq_name = ""
            $Radio/RadioLabel/HBoxContainer/Label.speakers = ""
            $Radio/RadioLabel/HBoxContainer/Label2.speakers = ""
            $Radio/Control/TapeLabel.text = loaded_tape.tape_name
            
            $Radio/Dial.mute()
            $Radio/Dial.cassette_mode = true     


func _check_text_safety(text):
    
    var lower_text = text.to_lower()
    
    var is_safe_as_is = BadWordsFilter.is_word_ok(lower_text)
    if not is_safe_as_is:
        return false
        
    for word in lower_text.split(" "):
        var is_word_safe = BadWordsFilter.is_word_ok(word)
        if not is_word_safe:
            return false
            
    var joined_text = lower_text.replace(" ", "")
        
    for word in BadWordsFilter.profanity_list:
        if word in lower_text:
            return false
        if word in joined_text:
            return false
            
    return true
            

# --------
# RECORDING CONTROLS
# --------


func _start_recording() -> void:
    effect.set_recording_active(true)
       

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
    if loaded_tape and (loaded_tape.player.playing or effect.is_recording_active()):
        $Tape/Gear1.rotation += gear_rotation_direction * gear_rotation_speed * delta
        $Tape/Gear2.rotation += gear_rotation_direction * gear_rotation_speed * delta
