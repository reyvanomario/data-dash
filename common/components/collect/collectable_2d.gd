class_name Collectable2D
extends Area2D

@export var identifier: String = ''
@export var audio_streams: Array[AudioStream] = []



signal collected

func collect() -> void:
	collected.emit()

func get_audio() -> AudioStream:
	if audio_streams.is_empty():
		return null
	return audio_streams.pick_random()


	
