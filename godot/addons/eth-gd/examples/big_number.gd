extends Node

func _ready():
	var super_big_number = BigNumber.new("0xFFFFFFFFFFFF")
	var another_super_big_number = BigNumber.new("0xFFFFFFFFFFFF")
	var super_duper_big_number = super_big_number.mul(another_super_big_number)
	
	print(super_duper_big_number.to_hex_string())
