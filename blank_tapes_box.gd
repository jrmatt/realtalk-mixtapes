extends Button

const HIDDEN_Y: float = 286
const HINT_Y: float = 0
const REVEAL_Y: float = 0


func _pressed() -> void:
    if not get_parent().get_parent().loaded_tape:
        _animate_tape_reveal()


func _on_focus_entered() -> void:
    _animate_tape_hint()
    

func _on_focus_exited() -> void:
    _animate_tape_hint_away()


func _reset_tape() -> void:
    $Control.position.y = HIDDEN_Y
    

func _animate_tape_reveal() -> void:
    var reveal_tape = create_tween()
    reveal_tape.tween_property($Control, "modulate:a", 0.0, 0.5)
    $AudioStreamPlayer.play()

    await reveal_tape.finished

    _reset_tape()
    release_focus()
    
    
func _animate_tape_hint() -> void:
    $Control.modulate.a = 1
    var hint_tape_up = create_tween()
    hint_tape_up.tween_property($Control, "position:y", HINT_Y, 0.3)
    $AudioStreamPlayer.play()
    

func _animate_tape_hint_away() -> void:
    var hint_away = create_tween()
    hint_away.tween_property($Control, "position:y", HIDDEN_Y, 0.3)
    $AudioStreamPlayer.play()
    
    
func animate_replace_tape() -> void:
    $Control.modulate.a = 100.0
    $Control.position.y = REVEAL_Y
    var replace_tape = create_tween()
    replace_tape.tween_property($Control, "position:y", HINT_Y, 0.3)
    $AudioStreamPlayer.play()

    grab_focus()
