extends Label


func _on_dial_playing_track(new_track: Variant) -> void:
    if new_track:
        var speaker_array = new_track.speakers
        var speakers = ", ".join(speaker_array)
        self.text = speakers
    else:
        self.text = ""
