class_name EthUtils extends Object

enum ETH_UTILS_ERROR { SIZE_EXCEED_PADDING_SIZE = 1 }

static func is_address(value: String):
	var regex = RegEx.new()
	regex.compile("^0x[a-fA-F0-9]{40}$")
	return regex.search(value) != null

static func padHex(hex: String, padLeft = true, size = 32) -> Array:
	if size == null: return [OK, hex]
	var stripped_hex = hex.replace("0x", "")
	if stripped_hex.length() > (size as int) * 2:
		return [ETH_UTILS_ERROR, "Hex size %d exceeds padding size %d" % [stripped_hex.length() / 2, size]]
	if padLeft:
		return [0, ("0x%s" % stripped_hex).lpad(size * 2, "0")]
	else:
		return [0, ("0x%s" % stripped_hex).rpad(size * 2, "0")]
