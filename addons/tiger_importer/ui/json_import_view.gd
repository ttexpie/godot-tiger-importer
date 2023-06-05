@tool
extends VBoxContainer

@onready var import_button: Button = $ButtonHBox/ImportButton
@onready var clear_button: Button = $ButtonHBox/ClearButton
@onready var file_dialog: FileDialog = $FileDialog
@onready var alert_dialog: AcceptDialog = $AlertDialog

signal data_imported(import_data)
signal data_cleared


func set_json_filepath(new_filepath: String) -> void:
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
	set_json_filepath("")
	data_cleared.emit()


func _on_file_dialog_file_selected(path: String) -> void:
	var import_data := TigerJsonImport.new()
	var error := import_data.load(path)

	if error != OK:
		var error_msg: String

		set_json_filepath("")
		
		call_deferred("alert_message", error_string(error))
	else:
		set_json_filepath(path)

		data_imported.emit(import_data)


func alert_message(error_msg: String):
	alert_dialog.dialog_text = error_msg
	alert_dialog.popup_centered()
