extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# shouldn't be able to save while recording
func _on_save_btn_pressed() -> void:
	var is_recording = $Radio/Recorder.is_recording
	var current_mix = $Radio/Recorder.current_mix
	if current_mix:
		$Radio/Recorder._stop_recording()
		$MixtapeStack.add_child(current_mix)
		print("Added current mix: ", current_mix)
		$Radio/Recorder.current_mix = null
