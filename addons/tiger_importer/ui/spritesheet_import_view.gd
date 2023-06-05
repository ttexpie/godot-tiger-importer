@tool
extends VBoxContainer

@onready var import_button: Button = $ButtonHBox/ImportButton
@onready var clear_button: Button = $ButtonHBox/ClearButton
@onready var file_dialog: FileDialog = $FileDialog
@onready var alert_dialog: AcceptDialog = $AlertDialog

signal spritesheet_imported(import_spritesheet)
signal spritesheet_cleared


func set_spritesheet_filepath(new_filepath: String) -> void:
	if new_filepath:
		import_button.text = new_filepath
		clear_button.show()
	else:
		import_button.text = "Import"
		clear_button.hide()


func _on_import_button_pressed() -> void:
	file_dialog.invalidate()
	file_dialog.popup_centered_ratio(0.5)


func _on_clear_button_pressed() -> void:
	set_spritesheet_filepath("")
	spritesheet_cleared.emit()


func _on_file_dialog_file_selected(path: String) -> void:
	var spritesheet := load(path)
	set_spritesheet_filepath(path)
	spritesheet_imported.emit(spritesheet)


func alert_message(error_msg: String):
	alert_dialog.dialog_text = error_msg
	alert_dialog.popup_centered()
