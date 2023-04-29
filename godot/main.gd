extends Node

@onready var client = $Client
@onready var vault = $Vault

func _ready():
	var accounts_res = await client.request("eth_accounts", [])
	print(accounts_res)
