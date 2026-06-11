extends Button


func _on_button_down() -> void:
    var start_event = InputEventAction.new()
    start_event.action = "rewind_time"
    start_event.pressed = true
    Input.parse_input_event(start_event)


func _on_button_up() -> void:
    var stop_event = InputEventAction.new()
    stop_event.action = "rewind_time"
    stop_event.pressed = false
    Input.parse_input_event(stop_event)
