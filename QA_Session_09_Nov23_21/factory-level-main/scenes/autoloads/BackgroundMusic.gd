## Singleton for playing background music.
# @name BackgroundMusic
# @singleton
extends AudioStreamPlayer

## A list of songs each mapped to a name.
# @type Dictionary
# @desc  This holds a bunch of songs, mapping each name of a file relative
#        to @constant MUSIC_PATH. Each call to @function play_music() is expects
#        a key from this dictionary.
export(Dictionary) var songs

## Path to the music folder
# @type String
const MUSIC_PATH := "res://assets/audio/music"

onready var tween = $Tween

func _enter_tree() -> void:
	stream = null

## Fades the music out.
# @desc  Call this function to fade the music over a period of time specified
#        by @a duration seconds. Once the fade is complete, the music stops.
func fade_out(duration: float) -> void:
	if not is_playing() or tween.is_active(): return
	if duration <= 0.0:
		push_error("invalid duration %f, needs to be greater than 0" % duration)
		return
	tween.interpolate_property(self, @"volume_db", null, -80.0, duration, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.start()

## Play a song from the mapping.
# @desc  Plays a song from the mapping specified by @a song. If @a position is specified
#        and is greater than zero, marks the position in the song (in seconds) to start
#        playback.
func play_music(song: String, position: float = 0.0) -> void:
	var audio_stream = songs.get(song)
	
	if not(song in songs):
		push_error("No song named \"%s\" exists in the list" % song)
		return
	var path := str(MUSIC_PATH, '/', audio_stream as String)
	audio_stream = load(path)
	if audio_stream == null: return
	stream = audio_stream as AudioStream
	play(position)

func _on_tween_completed(object: Object, key: NodePath) -> void:
	if object == self:
		if key == @"volume_db":
			stop()
