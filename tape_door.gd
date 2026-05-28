extends AnimatedSprite2D


func load_tape() -> void:
    frame = 1
    await get_tree().create_timer(0.7).timeout
    frame = 0
    
    
func open_door() -> void:
    frame = 1


func close_door() -> void:
    await get_tree().create_timer(0.3).timeout
    frame = 0
