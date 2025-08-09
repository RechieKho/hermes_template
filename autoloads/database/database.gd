extends Node

@export var default_entries := {}

var entries := {}

var path : String :
	set(p_value):
		entries = read(p_value).unwrap()
		path = p_value

static func read(p_path: String) -> Result:
	if not FileAccess.file_exists(p_path): return Result.make_error("ERROR: File '{0}' doesn't exists.".format([p_path]))
	var file := FileAccess.open(p_path, FileAccess.READ)
	if not Utility.is_object_valid(file): return Result.make_error("ERROR: Unable to open the file '{0}'.".format([p_path]))
	var content := file.get_as_text()
	var parsed = str_to_var(content)
	if typeof(parsed) != TYPE_DICTIONARY: return Result.make_error("ERROR: File '{0}' contains incompatible data.".format([p_path]))
	return Result.make_success(parsed as Dictionary)

static func write(p_path: String, p_entries: Dictionary) -> Result:
	var file := FileAccess.open(p_path, FileAccess.WRITE)
	if not Utility.is_object_valid(file): return Result.make_error("ERROR: Unable to open the file '{0}'.".format([p_path]))
	var content := var_to_str(p_entries)
	file.store_string(content)
	return Result.make_success(true)

func create(p_path: String) -> Result:
	var result := write(p_path, default_entries)
	if result.is_erroneous(): return result
	path = p_path
	return Result.make_success(true)

func store() -> Result:
	return write(path, entries)
