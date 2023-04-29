class_name Client extends Node

@export var rpc_url = "http://127.0.0.1:1248"

enum ClientRequestError { NO_RESULT_KEY }

var project_name = ProjectSettings.get("application/config/name")
var id = 0

func request(method: String, params: Array = []) -> Array:
	var req = HTTPRequest.new()
	add_child(req)
	
	var body = JSON.stringify({
		"jsonrpc": "2.0",
		"method": method,
		"params": params,
		"id": id
	})
	
	var error = req.request(rpc_url, ["Origin: " + project_name], HTTPClient.METHOD_POST, body)
	if (error != OK):
		return [error, null]
	var res = await req.request_completed
	
	var parsed_res = self.parse_response(res)
	
	remove_child(req)
	id += 1
	
	return parsed_res
	
func parse_response(response: Array):
	var result = response[0]
	
	if (result != HTTPRequest.Result.RESULT_SUCCESS):
		return [result, null]
	
	var body = response[3]
	var body_string = (body as PackedByteArray).get_string_from_utf8()
		
	var parser = JSON.new()
	var parse_error = parser.parse(body_string)
	var parsed_body = parser.data
	
	var response_code = response[1]
	if (response_code != HTTPClient.ResponseCode.RESPONSE_OK):
		if (parse_error != OK):
			return [response_code, body_string] # can't parse string as JSON
		else:
			if ("error" in parsed_body):
				var error = parsed_body.error
				return [error.code if "code" in error else response_code, error.message if "message" in error else error]
			else:
				return [response_code, parsed_body] # no error field on object
				
	if ("result" in parsed_body):
		return [OK, parsed_body.result]
	else:
		return [ClientRequestError.NO_RESULT_KEY, parsed_body] # no result field on object
