class_name Contract extends Node

@export var client: Client
@export var abi: JSON

func read(function_name: String, address: String, params: Array):
	var res = await client.request("eth_call", [])
	
func encodeFunctionData(function_name: String):
	pass

func getAbiItem(name: String):
	pass
