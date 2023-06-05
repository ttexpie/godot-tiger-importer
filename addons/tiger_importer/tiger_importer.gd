@tool
extends EditorPlugin

const import_ui_scene := preload("res://addons/tiger_importer/ui/import_ui.tscn")
const icon := preload("res://addons/tiger_importer/editor_icon.svg")

var import_ui: Control


func _enter_tree() -> void:
	import_ui = import_ui_scene.instantiate()
	get_editor_interface().get_editor_main_screen().add_child(import_ui)
	_make_visible(false)


func _exit_tree() -> void:
	if import_ui:
		import_ui.queue_free()


func _has_main_screen() -> bool:
	return true


func _make_visible(visible: bool) -> void:
	if import_ui:
		import_ui.visible = visible


func _get_plugin_name() -> String:
	return "Tiger Importer"


func _get_plugin_icon() -> Texture2D:
	return icon
