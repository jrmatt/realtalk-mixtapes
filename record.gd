extends Button

func _unhandled_input(_event: InputEvent) -> void:
    if Input.is_action_just_pressed("record"):
        pressed.emit()
        $AudioStreamPlayer.play()


func _pressed() -> void:
    pressed.emit()
    $AudioStreamPlayer.play()
