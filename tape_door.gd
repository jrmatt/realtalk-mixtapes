extends AnimatedSprite2D


func load_tape() -> void:
    await get_tree().create_timer(0.3).timeout
    frame = 1
    
    
func open_door() -> void:
    frame = 0


func close_door() -> void:
    await get_tree().create_timer(0.3).timeout
    frame = 1
