extends Node2D

var mix_to_save: Mixtape
var stack: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func _save_mix() -> void:
	stack.add_child(mix_to_save)
	print("Added current mix: ", mix_to_save)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
