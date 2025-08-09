extends Object
class_name Utility

func _init() -> void: assert(false, "`Utility` should not be instantiated.")

static func is_object_valid(p_object: Object) -> bool:
	return p_object != null and is_instance_valid(p_object) and not p_object.is_queued_for_deletion()

static func assure_signal_connected(p_signal: Signal, p_callable: Callable, p_connection_flags := 0) -> void:
	if not p_signal.is_connected(p_callable): p_signal.connect(p_callable, p_connection_flags)

static func assure_signal_disconnected(p_signal: Signal, p_callable: Callable) -> void:
	if p_signal.is_connected(p_callable): p_signal.disconnect(p_callable)

static func put_scene_from_file(p_resource_path: String, p_parent: Node, p_spawner: Node = null) -> Node:
	return put_scene_from_resource(load(p_resource_path) as PackedScene, p_parent, p_spawner)

static func put_scene_from_resource(p_resource: PackedScene, p_parent: Node, p_spawner: Node = null) -> Node:
	var node := p_resource.instantiate() as Node
	if is_object_valid(p_spawner): node.set_meta(&"spawner", p_spawner)
	p_parent.add_child(node)
	return node

static func get_spawner(p_node: Node) -> Node:
	return p_node.get_meta(&"spawner")

static func is_approx_equal(p_a, p_b) -> bool:
	if typeof(p_a) != typeof(p_b): return false
	if p_a is float: return is_approx_equal(p_a, p_b)
	elif p_a is Vector2: return p_a.is_equal_approx(p_b)
	elif p_a is Vector3: return p_a.is_equal_approx(p_b)
	elif p_a is Vector4: return p_a.is_equal_approx(p_b)
	elif p_a is Color: return p_a.is_equal_approx(p_b)
	elif p_a is AABB: return p_a.is_equal_approx(p_b)
	elif p_a is Transform2D: return p_a.is_equal_approx(p_b)
	elif p_a is Transform3D: return p_a.is_equal_approx(p_b)
	elif p_a is Rect2: return p_a.is_equal_approx(p_b)
	elif p_a is Quaternion: return p_a.is_equal_approx(p_b)
	elif p_a is Basis: return p_a.is_equal_approx(p_b)
	else: return p_a == p_b

static func play_animation_synchronous(p_animation_player: AnimationPlayer, p_animation_name: StringName) -> void:
	p_animation_player.play(p_animation_name)
	while await p_animation_player.animation_finished != p_animation_name: pass
