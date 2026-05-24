extends Node2D

var SaveScene = preload("res://save.tscn")

# What should the actual flow be:
# Load a cassette into drawer
#	Needs: is cassette loaded?
#	Needs: casssette blank or recorded?

# Press play and record simultaneously
#	If cassette blank, start recording, else nothing
# Pause recording
# Start recording again
# Stop recording & eject cassette (press twice to eject?)
#	(and pops the recording & play buttons back up)
#	is cassette loaded = false
# [DONE] Prompted to save it or discard it 
# [DONE] Saving adds it to the stack

# Press play
#	If cassette loaded:
#		If cassette blank, play with no sound
#		If cassette recorded, play recorded audio & display track info
# Press pause
#	Pause cassette
# Fast forward / back
# Press stop & ejects
# 	Place back on mixtape stack


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass


func _on_stop_btn_pressed() -> void:
    var current_mix = $Radio/Recorder.current_mix
    if current_mix:
        $Radio/Recorder._stop_recording()
        var new_save = SaveScene.instantiate()
        new_save.mix_to_save = current_mix
        new_save.stack = $MixtapeStack
        add_child(new_save)
        print("Kicked off a new save: ", new_save)
        $Radio/Recorder.current_mix = null
