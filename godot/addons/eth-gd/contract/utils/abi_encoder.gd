class_name AbiEncoder extends Object

enum ENCODE_ABI_ERROR { ENCODING_LENGTH_MISMATCH = 1, INSUFFICIENT_FIELDS = 2, UNRECOGNIZED_ABI_TYPE = 3, INVALID_ADDRESS = 4 }

static func encode_abi_parameters(params: Array, values: Array) -> Array:
	if params.size() != values.size():
		return [ENCODE_ABI_ERROR.ENCODING_LENGTH_MISMATCH, "[AbiEncoder.prepare_param] Expected %d arguments, got %d" % [params.size(), values.size()]]
	
	var prepared_params_res = prepare_params(params, values)
	
static func prepare_params(params: Array, values: Array) -> Array:
	var prepared_params = []
	for i in range(params.size()):
		var prepared_param_res = prepare_param(params[i], values[i])
		if prepared_param_res[0] != OK: return prepared_param_res
		prepared_params.push_back(prepared_param_res[1])
	return [OK, prepared_params]
	
static func prepare_param(param, value) -> Array:
	match param:
		{"type": "tuple", ..}:
			return encode_tuple(value, param)
		{"type": "address", ..}:
			return encode_address(value, param)
		{"type": "bool", ..}:
			return encode_bool(value, param)
		{"type": "string"}:
			return encode_string(value)
		{"type": var type}:
			var type_string = type as String
			if type_string.begins_with("bytes"):
				return encode_bytes(value, param)
			if type_string.begins_with("uint") || type_string.begins_with("int"):
				var signed = type_string.begins_with("int")
				return encode_number(value, signed)
			var array_components = get_array_components(type)
			if array_components == null: return [ENCODE_ABI_ERROR.UNRECOGNIZED_ABI_TYPE, "[AbiEncode.prepare_param] Unexepected ABI type: %s" % type]
			var length = array_components[0]
			var inner_type = array_components[1]
			param['type'] = inner_type
			return encode_array(value, length, param)
		_:
			return [ENCODE_ABI_ERROR.INSUFFICIENT_FIELDS, "[AbiEncoder.prepare_param] Expected `type` field to be present in param %s" % param]

static func get_array_components(type):
	var regex = RegEx.new()
	regex.compile("^(.*)\\[(\\d+)?\\]$")
	var res = regex.search(type)
	
	if res == null: return null
	
	match [res.get_string(2), res.get_string(1)]:
		[null, var inner_type]:
			return [null, inner_type]
		[var length, var inner_type]:
			return [int(length), inner_type]
		_:
			return null

static func encode_array(value, length, param):
	pass
	
static func encode_tuple(value, param):
	pass

static func encode_address(value, param) -> Array:
	if !EthUtils.is_address(value): return [ENCODE_ABI_ERROR.INVALID_ADDRESS, "[AbiEncoder.encode_address] Invalid address: %s" % value]
	var pad_hex_res = EthUtils.padHex(value)
	if (pad_hex_res[0] != OK): return pad_hex_res
	var pad_hex = pad_hex_res[1]
	return [OK, [false, pad_hex]]
	
static func encode_bool(value, param):
	pass

static func encode_number(value, signed: bool):
	pass

static func encode_string(value):
	pass

static func encode_bytes(value, param):
	pass
