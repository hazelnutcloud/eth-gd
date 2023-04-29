@tool
extends EditorPlugin

func _enter_tree():
	add_autoload_singleton("Keccak256", "res://addons/keccak256/keccak256.gd")


func _exit_tree():
	remove_autoload_singleton("Keccak256")
