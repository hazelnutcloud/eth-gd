class_name AbiFormatter extends Object

enum FORMAT_ABI_ERROR {INVALID_TYPE = 1, INSUFFICIENT_FIELDS = 2}

static func get_function_selector(signature):
	var hash = Keccak256.hash(signature)
	print(hash)
	return "0x%s" % hash.substr(2, 8)

static func format_abi_item(abi_item, include_name = false) -> Array:
	match abi_item:
		{'type': var type, 'name', 'inputs', ..}:
			match type:
				'function', 'event', 'error':
					var formatted_abi_params_res = format_abi_params(abi_item.inputs, include_name)
					if formatted_abi_params_res[0] != OK: return formatted_abi_params_res
					return [OK, "%s(%s)" % [abi_item.name, formatted_abi_params_res[1]]]
				_:
					return [FORMAT_ABI_ERROR.INVALID_TYPE, type]
		_:
			return [FORMAT_ABI_ERROR.INSUFFICIENT_FIELDS, abi_item]

static func format_abi_params(params: Array, include_name = false) -> Array:
	if params.size() == 0: return [OK, '']
	var formatted_params = []
	for param in params:
		var formatted_param_res = format_abi_param(param, include_name)
		if formatted_param_res[0] != OK: return formatted_param_res
		formatted_params.push_back(formatted_param_res[1])
	if include_name:
		return [OK, ", ".join(formatted_params)]
	else:
		return [OK, ",".join(formatted_params)]
	
static func format_abi_param(param, include_name = false) -> Array:
	match param:
		{'type': var type, 'components': var components, ..}:
			var formatted_components_res = format_abi_params(components, include_name)
			if formatted_components_res[0] != OK: return formatted_components_res
			return [OK, "(%s)%s" % [formatted_components_res[1], (type as String).substr('tuple'.length())]]
		{'name': var name, 'type': var type}:
			if include_name:
				return [OK, "%s %s" % [type, name]]
			else:
				return [OK, type]
		{'type': var type}:
			if include_name: return [FORMAT_ABI_ERROR.INSUFFICIENT_FIELDS, param]
			return [OK, type]
		_:
			return [FORMAT_ABI_ERROR.INSUFFICIENT_FIELDS, param]

static func is_arg_of_type(arg, abiParameter) -> bool:
	match abiParameter:
		{'type': 'address', ..}:
			var regex = RegEx.new()
			regex.compile("^0x[a-fA-F0-9]{40}$")
			var res = regex.search(arg)
			return res != null
		{'type': 'bool', ..}:
			return typeof(arg) == TYPE_BOOL
		{'type': 'function', ..}:
			return typeof(arg) == TYPE_STRING
		{'type': 'string', ..}:
			return typeof(arg) == TYPE_STRING
		{'type': 'tuple', 'components': var components, ..}:
			if typeof(arg) == TYPE_DICTIONARY:
				for component in components:
					if 'name' in component && component.name in arg:
						if !is_arg_of_type(arg[component.name], component): return false
				return true
			elif typeof(arg) == TYPE_ARRAY:
				for i in range(components.size()):
					var arg_element = arg[i]
					var component = components[i]
					if !is_arg_of_type(arg_element, component): return false
				return true
			return false
		{'type': var type}:
			# `(u)int<M>`: (un)signed integer type of `M` bits, `0 < M <= 256`, `M % 8 == 0`
			var regex = RegEx.new()
			regex.compile("^u?int(8|16|24|32|40|48|56|64|72|80|88|96|104|112|120|128|136|144|152|160|168|176|184|192|200|208|216|224|232|240|248|256)?$")
			var res = regex.search(type)
			if res != null:
				return arg is BigNumber || arg is BaseBigNumber
			
			# `bytes<M>`: binary type of `M` bytes, `0 < M <= 32`
			regex = RegEx.new()
			regex.compile("^bytes([1-9]|1[0-9]|2[0-9]|3[0-2])?$")
			res = regex.search(type)
			if res != null:
				return typeof(arg) == TYPE_STRING || typeof(arg) == TYPE_PACKED_BYTE_ARRAY
			
			# fixed-length (`<type>[M]`) and dynamic (`<type>[]`) arrays
			regex = RegEx.new()
			regex.compile("[a-z]+[1-9]{0,3}(\\[[0-9]{0,}\\])+$")
			res = regex.search(type)
			if res == null: return false
			if typeof(arg) != TYPE_ARRAY: return false
			regex = RegEx.new()
			regex.compile("(\\[[0-9]{0,}\\])$")
			var element_type = regex.sub(type, "")
			abiParameter["type"] = element_type
			for arg_element in arg:
				if !is_arg_of_type(arg_element, abiParameter): return false
			return true
		_:
			return false
