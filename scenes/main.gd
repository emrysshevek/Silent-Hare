extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	BackgroundMusicManager.crossfade_to(BackgroundMusicManager.BackgroundTrack.MAIN)

func _on_button_button_up() -> void:
	var ap: AnimationPlayer = get_node("AnimationPlayer")
	ap.play("start")
	ap.animation_finished.connect(start)

func start(name) -> void:
	get_tree().change_scene_to_file("res://scenes/world/world.tscn")
