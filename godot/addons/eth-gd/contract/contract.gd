@icon("res://addons/eth-gd/eth_logo.svg")
class_name Contract extends Node

@export var client: Client
@export var abi: JSON

enum ContractError {ABI_FUNCTION_NOT_FOUND = 1}

func read(function_name: String, address: String, args:= []):
	var res = await client.request("eth_call", [])
	
func encode_function_data(function_name: String, args:= []):
	var abi_item = get_abi_item(function_name, args)
	if abi_item == null: return [ContractError.ABI_FUNCTION_NOT_FOUND, function_name]
	if abi_item.type != 'function': return [ContractError.ABI_FUNCTION_NOT_FOUND, function_name]
	
	var signature = AbiFormatter.format_abi_item(abi_item)
	var selector = AbiFormatter.get_function_selector(signature[1])
	return [signature, selector]

func get_abi_item(name: String, args:= []):
	var abi_items = (abi.data as Array).filter(func(item): return 'name' in item && item.name == name)

	if abi_items.size() == 0: return null
	if abi_items.size() == 1: return abi_items[0]

	for abi_item in abi_items:
		if !('inputs' in abi_item): continue
		
		if abi_item.inputs.size() == 0:
			if args.size() == 0: return abi_item
			continue
			
		var matched = false
		for i in range(args.size()):
			matched = i < abi_item.inputs.size()
			if !matched: break
			
			var arg = args[i]
			var input = abi_item.inputs[i]
			matched = AbiFormatter.is_arg_of_type(arg, input)
			if !matched: break
		if matched: return abi_item
	
	return abi_items[0]
