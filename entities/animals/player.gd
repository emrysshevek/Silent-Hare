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
		audio.stream = run_sound
		audio.play()
	else:
		velocity = direction * walk_speed
		audio.stream = walk_sound
		audio.play()

	move_and_slide()

func _on_area_2d_area_entered(area:Area2D) -> void:
	var food : Food = area.get_parent()
	food.collect()


func _on_hearing_area_animal_entered_sense_range(which_sense: SenseArea, which_animal: Animal) -> void:
	if which_animal is Player:
		return
	
	print("animal entered player range")
	BackgroundMusicManager.crossfade_to(BackgroundMusicManager.BackgroundTrack.CLOSE)


