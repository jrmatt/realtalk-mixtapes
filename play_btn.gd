extends Button


func _unhandled_input(_event: InputEvent) -> void:
    if Input.is_action_just_pressed("play"):
        _pressed()


func _pressed() -> void:
    grab_focus()
    pressed.emit()
    $AudioStreamPlayer.play()
