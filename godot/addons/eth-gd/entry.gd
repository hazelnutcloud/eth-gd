@tool
extends EditorPlugin

func _enter_tree():
	add_autoload_singleton("Keccak256", "res://addons/eth-gd/keccak256.gd")
	add_custom_type("Client", "Node", preload("res://addons/eth-gd/client.gd"), preload("res://icon.svg"))
	add_custom_type("Contract", "Node", preload("res://addons/eth-gd/contract.gd"), preload("res://icon.svg"))


func _exit_tree():
	remove_autoload_singleton("Keccak256")
	remove_custom_type("Client")
	remove_custom_type("Contract")
