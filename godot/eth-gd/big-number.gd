class_name BigNumber extends BaseBigNumber

func _init(value_str: String):
	if (value_str.begins_with("0x")):
		self.from_hex_string(value_str)
	else:
		self.from_dec_string(value_str)
