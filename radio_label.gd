extends ScrollContainer

@onready var label = $HBoxContainer/Label

func _process(delta: float) -> void:
    scroll_horizontal += 2
        
    if scroll_horizontal > label.size.x:
        scroll_horizontal = 0
