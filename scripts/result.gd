extends RefCounted
class_name Result

var success : Variant = null
var error : Variant = null

static func make_success(p_success_value: Variant) -> Result:
	var result = Result.new()
	result.success = p_success_value
	return result

static func make_error(p_error_value: Variant) -> Result:
	var result = Result.new()
	result.error = p_error_value
	return result

func is_successful() -> bool:
	return success != null

func is_erroneous() -> bool:
	return error != null

func unwrap() -> Variant:
	assert(is_successful())
	return success

func unwrap_error() -> Variant:
	assert(is_erroneous())
	return error
