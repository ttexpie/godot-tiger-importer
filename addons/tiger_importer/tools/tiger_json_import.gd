extends Object

class_name TigerJsonImport

const ANIMATION_TEMPLATE = {
	name = TYPE_STRING,
	looping = TYPE_BOOL,
	sequences = [
		{
			direction = TYPE_STRING,
			keyframes = [
				{
					x = TYPE_INT,
					y = TYPE_INT,
					atlasX = TYPE_INT,
					atlasY = TYPE_INT,
					width = TYPE_INT,
					height = TYPE_INT,
					duration = TYPE_FLOAT,
					hitboxes = [
						{
							name = TYPE_STRING,
							x = TYPE_INT,
							y = TYPE_INT,
							width = TYPE_INT,
							height = TYPE_INT
						}
					]
				}
			]
		}
	]
}

var json_filepath: String
var json_data: Dictionary

func load(filepath: String) -> int:
	var file = FileAccess.open(filepath, FileAccess.READ)
	if(file == null):
		var error := FileAccess.get_open_error()
		return error
	
	var file_text = file.get_as_text()
	
	var json = JSON.new()
	var error := json.parse(file_text)
	
	if error != OK:
		return ERR_PARSE_ERROR
	
	error = _validate_json(json)
	if error != OK:
		return error

	json_filepath = filepath
	json_data = json.get_data()

	return OK


func get_animations() -> Array[TigerAnimation]:
	var anim_array: Array[TigerAnimation] = []
	for animation in json_data["animations"]:
		var tiger_anim := TigerAnimation.new(animation["name"], animation["looping"])
		for sequence in animation["sequences"]:
			var tiger_seq := TigerAnimation.Sequence.new(sequence["direction"])
			for keyframe in sequence["keyframes"]:
				var tiger_key := TigerAnimation.Keyframe.new(
					keyframe["x"], 
					keyframe["y"],
					keyframe["atlasX"],
					keyframe["atlasY"],
					keyframe["width"],
					keyframe["height"],
					keyframe["duration"]
				)
				tiger_seq.add_keyframe(tiger_key)
			tiger_anim.add_sequence(tiger_seq)
		anim_array.push_back(tiger_anim)
	return anim_array


func _validate_json(json: JSON) -> int:
	var data = json.get_data()
	
	if not (data is Dictionary and data.has("animations")):
		
		return ERR_INVALID_DATA
	
	for animation in data.animations:
		if not _match_template(animation, ANIMATION_TEMPLATE):
			printerr("json is not formatted correctly")
			return ERR_INVALID_DATA

	return OK


func _match_template(data, template) -> bool:
	match typeof(template):
		TYPE_INT:
			# When parsed, the JSON interprets integer values as floats
			if template == TYPE_INT and typeof(data) == TYPE_FLOAT:
				return true
			return typeof(data) == template
		TYPE_DICTIONARY:
			if typeof(data) != TYPE_DICTIONARY:
				return false

			if not data.has_all(template.keys()):
				return false

			for key in template:
				if key == "hitboxes":
					continue # no support for hitboxes as of now
				if not _match_template(data[key], template[key]):
					return false
		TYPE_ARRAY:
			if typeof(data) != TYPE_ARRAY:
				return false

			if data.is_empty():
				return false

			for element in data:
				if not _match_template(element, template[0]):
					return false

	return true
