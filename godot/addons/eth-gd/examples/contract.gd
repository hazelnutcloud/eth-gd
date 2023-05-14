extends Node

@onready var contract: Contract = $Contract
@onready var client: Client = $Client

func _ready():
	var encoded_res = contract.encode_function_data("balanceOf", ["0xd2be6586c9ed3b940396db1893c6a0e0d52e1bc3"])
	print(encoded_res)
