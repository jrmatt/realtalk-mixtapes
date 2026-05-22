extends Node2D

var mix_to_save: Mixtape
var stack: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func _save_mix() -> void:
	stack.add_child(mix_to_save)
	print("Added current mix: ", mix_to_save)


func _on_save_btn_pressed() -> void:
	_save_mix()
	queue_free()


func _on_discard_btn_pressed() -> void:
	queue_free()
