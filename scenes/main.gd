extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	BackgroundMusicManager.crossfade_to(BackgroundMusicManager.BackgroundTrack.MAIN)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("dig"):
		var ap: AnimationPlayer = get_node("AnimationPlayer")
		ap.play("start")
		ap.animation_finished.connect(start)

func start(name) -> void:
	get_tree().change_scene_to_file("res://scenes/world/world.tscn")
