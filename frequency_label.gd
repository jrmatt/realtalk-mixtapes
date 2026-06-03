extends Label

const colors = {
    "Black Art": "#E5A377",
    "Across Generations": "#5A7BFF",
    "Art Economy": "#786DCB",
    "Local Scene": "#88C5A7",
    "Gentrification": "#96BACD",
    "Art to Thrive": "#EA99D1",
    "Beginnings": "#9DB66F"
}


func _on_dial_playing_freq(new_freq: Variant, alpha: float) -> void:
    if new_freq:
        text = new_freq + ": "
        var color = colors[new_freq]
        set("theme_override_colors/font_color", color)

    else:
        text = ""

    modulate.a = alpha
