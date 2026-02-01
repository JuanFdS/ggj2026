class_name GameElementUtils
extends Node

static func is_in_layer(node: Node) -> bool:
	var parent_node = node.get_parent()
	while parent_node:
		if parent_node.is_in_group("layer"):
			return true
		parent_node = parent_node.get_parent()
	return false

static func is_completed() -> bool:
	var level = LevelManager.get_tree().get_first_node_in_group("level")
	if not level:
		return false
	return level.completed()
