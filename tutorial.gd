extends Node2D
    

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed('ui_left') or event.is_action_pressed('ui_right') or event.is_action_pressed('ui_up') or event.is_action_pressed('ui_down'):
        _highlight_control($Controller/LeftJoyHighlight)
    if event.is_action_pressed('wheel_left') or event.is_action_pressed('wheel_right') or event.is_action_pressed('wheel_up') or event.is_action_pressed('wheel_down'):
        _highlight_control($Controller/RightJoyHighlight)
    if event.is_action_pressed('rewind_time'):
        _highlight_control($Controller/LeftBtnHighlight)
    if event.is_action_pressed('record'):
        _highlight_control($Controller/XHighlight)
    if event.is_action_pressed('play'):
        _highlight_control($Controller/YHighlight)
    if event.is_action_pressed('stop_eject'):
        _highlight_control($Controller/BHighlight)
    if event.is_action_pressed('ui_accept') or event.is_action_pressed('ui_select'):
        _highlight_control($Controller/AHighlight)   


func _highlight_control(node: Node) -> void:
        node.visible = true
        await get_tree().create_timer(0.7).timeout
        node.visible = false
