extends Node

enum BackgroundTrack {
	MAIN,
	HAPPY,
	PEACE,
	CLOSE,
	CHASE,
	CHASE_CLOSE,
	DEATH
}

# References to the nodes in our scene
@onready var _anim_player: AnimationPlayer = $AnimationPlayer
@onready var _track_1: AudioStreamPlayer = $Track1
@onready var _track_2: AudioStreamPlayer = $Track2

var track_idx = 0

var tracks: Array[AudioStream] = [
	preload("res://assets/music/Main theme.mp3"),
	preload("res://assets/music/Main theme happy.mp3"),
	preload("res://assets/music/Peace.mp3"),
	preload("res://assets/music/Close.mp3"),
	preload("res://assets/music/Chase.mp3"),
	preload("res://assets/music/Chase Very Close.mp3"),
]

# crossfades to a new audio stream
func crossfade_to(track: BackgroundTrack) -> void:
	# If both tracks are playing, we're calling the function in the middle of a fade.
	# We return early to avoid jumps in the sound.
	if _track_1.playing and _track_2.playing:
		return

	# The `playing` property of the stream players tells us which track is active. 
	# If it's track two, we fade to track one, and vice-versa.
	var audio_stream := tracks[track]
	if _track_2.playing:
		_track_1.stream = audio_stream
		_track_1.play()
		_anim_player.play("FadeToTrack1")
	else:
		_track_2.stream = audio_stream
		_track_2.play()
		_anim_player.play("FadeToTrack2")

func skip() -> void:
	track_idx = (track_idx + 1) % len(tracks)
	crossfade_to(track_idx)
