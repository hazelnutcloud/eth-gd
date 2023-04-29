extends Node

@onready var client = $Client
@onready var vault = $Vault

func _ready():
	var accounts_res = await client.request("eth_accounts", [])
	if (accounts_res[0] != OK):
		print("An error occured: ", accounts_res[1])
		return
		
	var accounts = accounts_res[1]
	print("Accounts: ", accounts)
