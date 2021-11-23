class_name AudioPack
extends Resource

# The name of the stream.
export(String) var name

# The audio stream itself.
export(AudioStream) var stream: AudioStream

# The volume of the stream.
export(float) var volume_db: float = 0
