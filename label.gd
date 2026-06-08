extends Label


const colors = {
    "Black Art": "#E5A377",
    "Generations": "#5A7BFF",
    "Art Economy": "#786DCB",
    "Local Scene": "#88C5A7",
    "Gentrification": "#96BACD",
    "Art to Thrive": "#EA99D1",
    "Beginnings": "#9DB66F"
}

var freq_name := ""
var speakers := ""


func _on_dial_playing_freq(new_freq: Variant, alpha: float) -> void:
    if new_freq:
        freq_name = new_freq + ": "
        var color = colors[new_freq]
        set("theme_override_colors/font_color", color)

    else:
        freq_name = ""

    modulate.a = alpha


func _on_dial_playing_track(new_track: Variant, alpha: float) -> void:
    if new_track:
        var speaker_array = new_track.speakers
        speakers = ", ".join(speaker_array)
        speakers = speakers + " "

    else:
        speakers = ""

    modulate.a = alpha
    

func _process(delta: float) -> void:
    text = freq_name + speakers
