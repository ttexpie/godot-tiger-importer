extends Object

class_name TigerAnimation

var name: String
var looping: bool
var sequences: Array[Sequence] = []
var fixed: bool


func _init(anim_name: String, loop: bool) -> void:
	name = anim_name
	looping = loop


func add_sequence(sequence: Sequence) -> void:
	sequences.push_back(sequence)
	fixed = sequences.size() == 1


class Sequence:
	var direction: String
	var keyframes: Array[Keyframe] = []
	var length: float
	
	func _init(dir: String) -> void:
		direction = dir
	
	func add_keyframe(keyframe: Keyframe) -> void:
		keyframes.push_back(keyframe)
		length += keyframe.duration


class Keyframe:
	var x: int
	var y: int
	var atlas_x: int
	var atlas_y: int
	var width: int
	var height: int
	var duration: float
	
	func _init(x: int, y: int, atlas_x: int, atlas_y: int, width: int, 
			height: int, duration_ms: float) -> void:
		self.x = x
		self.y = y
		self.atlas_x = atlas_x
		self.atlas_y = atlas_y
		self.width = width
		self.height = height
		duration = duration_ms / 1000
