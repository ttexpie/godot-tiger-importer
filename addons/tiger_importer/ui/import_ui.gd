@tool
extends PanelContainer

@onready var hsplit_container: HSplitContainer = $HSplitContainer
@onready var scroll_container: ScrollContainer = $HSplitContainer/ScrollContainer
@onready var generate_button: Button = %GenerateButton
@onready var spritesheet_display: TextureRect = $HSplitContainer/SpritesheetDisplay

var spritesheet: Texture2D
var json_data: TigerJsonImport
var sprite: Sprite2D
var anim_player: AnimationPlayer


func _ready() -> void:
	hsplit_container.split_offset = 500


func _process(delta: float) -> void:
	generate_button.disabled = (spritesheet == null) or (json_data == null)


func _on_spritesheet_import_view_spritesheet_imported(import_spritesheet: Texture2D) -> void:
	spritesheet = import_spritesheet
	spritesheet_display.texture = spritesheet


func _on_spritesheet_import_view_spritesheet_cleared() -> void:
	spritesheet = null
	spritesheet_display.texture = preload("res://addons/tiger_importer/godottiger.svg")


func _on_json_import_view_data_imported(import_data: TigerJsonImport) -> void:
	json_data = import_data


func _on_json_import_view_data_cleared() -> void:
	json_data = null


func _on_node_selection_view_sprite_selected(sprite) -> void:
	self.sprite = sprite


func _on_node_selection_view_anim_player_selected(anim_player) -> void:
	self.anim_player = anim_player


func _on_generate_button_pressed() -> void:
	TigerAnimGenerator.generate_animations(json_data, spritesheet, sprite, anim_player)

