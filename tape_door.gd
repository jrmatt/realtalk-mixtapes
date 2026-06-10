extends AnimatedSprite2D

func _ready() -> void:
    frame = 0


func load_tape() -> void:
    close_door()
    
    
func open_door() -> void:
    frame = 0
    #$DoorOpenSound.play()
    $DoorClosedSound.play()

func close_door() -> void:
    await get_tree().create_timer(0.3).timeout
    frame = 1
    #$DoorClosedSound.play()
    $DoorClosedSound.play()
