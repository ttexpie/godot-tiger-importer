@tool
extends Popup

class_name SelectNodeDialog

@onready var edited_scene_view: VBoxContainer = $MarginContainer/Body/EditedSceneView
@onready var scene_tree: Tree = $MarginContainer/Body/EditedSceneView/SceneTree

@export var disabled_icon_modulate: Color

var class_filters: Array = []
var edited_scene_root: Node

signal error_occurred(message)
signal node_selected(selected_node)


func _ready() -> void:
	scene_tree.columns = 2
	scene_tree.set_column_expand(1, false)


func create_tree() -> bool:
	edited_scene_root = get_tree().edited_scene_root
	
	if edited_scene_root == null:
		error_occurred.emit("No scene selected")
		return false
	if edited_scene_root.scene_file_path == null:
		error_occurred.emit("Unsaved scene")
		return false
	
	scene_tree.clear()
	var filtered_node_count := _add_node_to_tree(edited_scene_root)
	if (not class_filters.is_empty() and filtered_node_count == 0):
		error_occurred.emit("No such nodes in current editor scene")
		return false
	
	return true

func _add_node_to_tree(node: Node, parent: TreeItem = null) -> int:
	var tree_item := scene_tree.create_item(parent)
	var node_class := node.get_class()
	
	tree_item.set_icon(0, get_theme_icon(node_class, "EditorIcons"))
	tree_item.set_text(0, node.name)
	tree_item.set_text(1, edited_scene_root.get_path_to(node))
	
	var filtered_node_count := 0
	if class_filters:
		var is_valid := false
		for filter in class_filters:
			if node.is_class(filter):
				is_valid = true
				filtered_node_count += 1
				break
		if not is_valid:
			tree_item.set_selectable(0, false)
			tree_item.set_selectable(1, false)
			tree_item.set_icon_modulate(0, disabled_icon_modulate)
			tree_item.set_custom_color(0, disabled_icon_modulate)
			tree_item.set_custom_color(1, disabled_icon_modulate)
	
	for child in node.get_children():
		if child.owner == edited_scene_root:
			filtered_node_count += _add_node_to_tree(child, tree_item)
	
	return filtered_node_count


func select_dialog(filter: Array, ratio: float = 0.5) -> void:
	class_filters = filter
	if not create_tree():
		return
	popup_centered_ratio(ratio)


func _on_scene_tree_item_activated() -> void:
	var selected_item := scene_tree.get_selected()
	if selected_item:
		var node_path := selected_item.get_text(1)
		var selected_node := edited_scene_root.get_node(node_path)
		node_selected.emit(selected_node)
		hide()


func _on_confirm_button_pressed() -> void:
	_on_scene_tree_item_activated()


func _on_cancel_button_pressed() -> void:
	hide()
