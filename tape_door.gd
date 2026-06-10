extends AnimatedSprite2D


func _ready() -> void:
    frame = 0


func open_door_empty() -> void:
    $TapeGears.visible = false
    frame = 0
    $DoorSound.play()
    
    
func open_door_loaded() -> void:
    $TapeGears.visible = false
    frame = 2
    $DoorSound.play()
        

func close_door_empty() -> void:
    await get_tree().create_timer(0.5).timeout
    $TapeGears.visible = false
    frame = 1
    $DoorSound.play()
    

func close_door_loaded() -> void:
    await get_tree().create_timer(0.5).timeout
    $TapeGears.visible = true
    frame = 3
    $DoorSound.play()   
