class_name Fox extends Animal

var walk_sound = load("res://assets/sounds/Fox/Fox Walk.mp3")
var run_sound = load("res://assets/sounds/Fox/Fox Run.mp3")
var bite_sound = load("res://assets/sounds/Fox/Bite.mp3")
var deathbite_sound = load("res://assets/sounds/Fox/DeathBite.mp3")

@onready var bite_sound_player: AudioStreamPlayer2D = $BiteSoundPlayer