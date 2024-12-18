class_name Player extends Animal

@onready var audio: AudioStreamPlayer2D = get_node("AudioStreamPlayer2D")

func _ready() -> void:
	print(audio)

func _physics_process(_delta: float) -> void:
		
	var direction = Input.get_vector("left", "right", "up", "down")

	if direction == Vector2.ZERO:
		velocity = Vector2.ZERO
		audio.stop()
		return

	if Input.is_action_pressed("sprint"):
		velocity = direction * run_speed
		if not audio.stream == run_sound or not audio.playing:
			audio.stream = run_sound
			audio.play()
	else:
		velocity = direction * walk_speed
		if not audio.stream == walk_sound or not audio.playing:
			audio.stream = walk_sound
			audio.play()

	print(audio.stream.resource_path, " ", audio.playing)
	move_and_slide()

func _on_area_2d_area_entered(area:Area2D) -> void:
	var food : Food = area.get_parent()
	food.collect()
