extends Button


func _pressed() -> void:
    if not get_parent().loaded_tape:
        _animate_tape_reveal()
        _reset_tape()


func _animate_tape_reveal() -> void:
    var reveal_tape = create_tween()
    reveal_tape.tween_property($Control, "position:y", 0, .4)
    
    await get_tree().create_timer(.8).timeout
    
    var hide_tape = create_tween()
    hide_tape.tween_property($Control, "modulate:a", 0.0, .1)
        

func _reset_tape() -> void:
    $Control.position.y = 286
    $Control.modulate.a = 100
