extends Node2D
    #
#
#func _unhandled_input(event: InputEvent) -> void:
    #if event.is_action_pressed('ui_left') or event.is_action_pressed('ui_right') or event.is_action_pressed('ui_up') or event.is_action_pressed('ui_down'):
        #_highlight_control($LeftJoy/LeftJoyHighlight)
    #if event.is_action_pressed('wheel_left') or event.is_action_pressed('wheel_right') or event.is_action_pressed('wheel_up') or event.is_action_pressed('wheel_down'):
        #_highlight_control($RightJoy/RightJoyHighlight)
    #if event.is_action_pressed('rewind_time'):
        #_highlight_control($Rewind/RewindHighlight)
    #if event.is_action_pressed('record'):
        #_highlight_control($X/XHighlight)
    #if event.is_action_pressed('play'):
        #_highlight_control($Y/YHighlight)
    #if event.is_action_pressed('stop_eject'):
        #_highlight_control($B/BHighlight)
    #if event.is_action_pressed('ui_accept') or event.is_action_pressed('ui_select'):
        #_highlight_control($A/AHighlight)   
#
#
#func _highlight_control(node: Node) -> void:
        #node.visible = true
        #await get_tree().create_timer(0.7).timeout
        #node.visible = false
