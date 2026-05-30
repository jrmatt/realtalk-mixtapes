extends Label

func _on_bounds_playing_freq(new_freq: Variant) -> void:
    if new_freq:
        self.text = new_freq + ": "
    else:
        self.text = ""
