@tool
extends VBoxContainer

class_name TigerNodeSelection

@onready var sprite_button: Button = $SpriteButton
@onready var anim_player_button: Button = $AnimPlayerButton
@onready var select_node: SelectNodeDialog = $SelectNodeDialog
@onready var alert: AcceptDialog = $AlertDialog

var sprite: Sprite2D
var anim_player: AnimationPlayer

signal sprite_selected(sprite)
signal anim_player_selected(anim_player)


func _on_sprite_button_pressed() -> void:
	select_node.select_dialog(["Sprite2D"])


func _on_anim_player_button_pressed() -> void:
	select_node.select_dialog(["AnimationPlayer"])


func _on_select_node_dialog_node_selected(selected_node) -> void:
	if selected_node is Sprite2D:
		sprite = selected_node
		sprite_selected.emit(sprite)
		sprite_button.text = sprite.owner.get_parent().get_path_to(sprite)
	elif selected_node is AnimationPlayer:
		anim_player = selected_node
		anim_player_selected.emit(anim_player)
		anim_player_button.text = anim_player.owner.get_parent().get_path_to(anim_player)


func _on_select_node_dialog_error_occurred(message: String) -> void:
	alert.dialog_text = message
	alert.popup_centered()
