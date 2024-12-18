class_name SoundComponent extends Node2D

@export var sounds: Dictionary # Key should be string representing name, and value should be AudioStream

func play_sound(sound_name: String, _duration:=-0.0) -> void:
	pass