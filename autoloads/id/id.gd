extends Node

const CURRENT_ID_DATABASE_KEY := &"ID.current_id"
const UNREGISTERED_IDS_DATABASE_KEY := &"ID.unregistered_ids"

var current_id : int :
	set(p_value): Database.entries.set(CURRENT_ID_DATABASE_KEY, p_value)
	get: return Database.entries.get_or_add(CURRENT_ID_DATABASE_KEY, 0)

var unregistered_ids : PackedInt64Array :
	set(p_value): Database.entries.set(UNREGISTERED_IDS_DATABASE_KEY, p_value)
	get: return Database.entries.get_or_add(UNREGISTERED_IDS_DATABASE_KEY, PackedInt64Array())

func generate() -> int:
	if not unregistered_ids.is_empty():
		var last_index := len(unregistered_ids) - 1
		var unregistered_id := unregistered_ids.get(last_index)
		unregistered_ids.remove_at(last_index)
		return unregistered_id
	var id := current_id
	current_id += 1
	return id

func unregister(p_id: int) :
	unregistered_ids.append(p_id)
