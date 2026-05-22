extends Node2D

var SaveScene = preload("res://save.tscn")

# What should the actual flow be:
# Load a new cassette into drawer
# Press play and record simultaneously
# Able to press pause
# Pressing stop stops recording & ejects (and pops the recording & play buttons back up)
# Prompted to save it or discard it
# Saving adds it to the stack

# Load an existing cassette into drawer
# Press play
# Press pause
# Fast forward / back
# Press stop & ejects


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
		new_save._save_mix()
		$Radio/Recorder.current_mix = null
