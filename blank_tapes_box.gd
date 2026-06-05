extends Button


func _pressed() -> void:
    if not get_parent().loaded_tape:
        _animate_tape_reveal()
        _reset_tape()


func _on_focus_entered() -> void:
    _animate_tape_hint()
    

func _on_focus_exited() -> void:
    _animate_tape_hint_away()


func _reset_tape() -> void:
    $Control.position.y = 286
    $Control.modulate.a = 100
    

func _animate_tape_reveal() -> void:
    $Control.position.y = 200
    var reveal_tape = create_tween()
    reveal_tape.tween_property($Control, "position:y", 0, .4)
    
    await get_tree().create_timer(0.8).timeout
    
    var hide_tape = create_tween()
    hide_tape.tween_property($Control, "modulate:a", 0.0, .1)
    
    
func _animate_tape_hint() -> void:
    var hint_tape_up = create_tween()
    hint_tape_up.tween_property($Control, "position:y", 200, .3)
    

func _animate_tape_hint_away() -> void:
    var hint_away = create_tween()
    hint_away.tween_property($Control, "position:y", 286, .3)
