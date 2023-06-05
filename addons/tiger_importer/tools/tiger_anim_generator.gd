@tool
extends Node

class_name TigerAnimGenerator


static func generate_animations(tiger_data: TigerJsonImport, spritesheet: Texture2D, 
		sprite: Sprite2D, anim_player: AnimationPlayer) -> int:
	if tiger_data == null or tiger_data.json_data == null:
		return ERR_INVALID_PARAMETER
	if anim_player == null:
		return ERR_INVALID_PARAMETER
	if spritesheet == null:
		return ERR_INVALID_PARAMETER
	
	var anim_library: AnimationLibrary
	if anim_player.has_animation_library(""):
		anim_library = anim_player.get_animation_library("")
	else:
		anim_library = AnimationLibrary.new()
		anim_player.add_animation_library("", anim_library)
	var sprite_path := str(anim_player.get_node(anim_player.root_node).get_path_to(sprite))
	
	var tracks := {
		"region" : {
			path = (sprite_path + ":region_rect"),
		},
		"offset" : {
			path = (sprite_path + ":offset")
		}
	}
	
	for animation in tiger_data.get_animations():
		for sequence in animation.sequences:
			var anim_name: String
			if animation.fixed:
				anim_name = animation.name
			else:
				anim_name = str(animation.name, "_", sequence.direction)
			
			var godot_anim: Animation
			if anim_library.has_animation(anim_name):
				godot_anim = anim_library.get_animation(anim_name)
			else:
				godot_anim = Animation.new()
				anim_library.add_animation(anim_name, godot_anim)
			
			for track_name in tracks:
				var track : Dictionary = tracks[track_name]
				track.idx = godot_anim.find_track(track.path, Animation.TYPE_VALUE)
				if track.idx == -1:
					track.idx = godot_anim.add_track(Animation.TYPE_VALUE)
					godot_anim.track_set_path(track.idx, track.path)
				else:
					for key_idx in range(godot_anim.track_get_key_count(track.idx)):
						godot_anim.track_remove_key(track.idx, 0)
				godot_anim.value_track_set_update_mode(track.idx, Animation.UPDATE_DISCRETE)
				godot_anim.track_set_enabled(track.idx, true)
			
			var time := 0.0
			for keyframe in sequence.keyframes:
				var region := Rect2(keyframe.atlas_x, keyframe.atlas_y, keyframe.width, keyframe.height)
				godot_anim.track_insert_key(tracks.region.idx, time, region)
				time += keyframe.duration
			godot_anim.length = time
			godot_anim.loop_mode = Animation.LOOP_LINEAR if animation.looping else Animation.LOOP_NONE
	
	sprite.texture = spritesheet
	sprite.region_enabled = true
	sprite.centered = true
	
	return OK
