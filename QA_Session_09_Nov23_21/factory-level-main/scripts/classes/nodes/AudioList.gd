class_name AudioList
extends AudioStreamPlayer

export(Array, Resource) var audio_list: Array

var _streams: = {}

func play_stream(stream_name: String, from_position: float = 0.0):
	var is_in_dict: bool = _streams.has(stream_name)
	if not is_in_dict:
		push_error("No stream named '%s' located in audio list" % stream_name)
	else:
		stream = _streams[stream_name]
		play(from_position)

func _enter_tree():
	assert(not audio_list.empty(), "No audio packs defined for AudioList")
	
	for pack in audio_list:
		assert(pack is AudioPack,
		"element %d of property 'audio_list' not an AudioPack" % audio_list.find(pack))
		_streams[pack.name] = pack.stream
