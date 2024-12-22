class_name IdleState extends PlayerState

func enter(_prev_state_path: String, _data := {}):
	player.velocity = Vector2.ZERO
	player.audio.stop()
	player.sprite.animation = "idle"
	player.hearable.set_radius(player.hearable_range)

func physics_update(delta: float) -> void:
	if Input.is_action_pressed("hide"):
		finished.emit(HIDE)
	if Input.is_action_pressed("dig"):
		finished.emit(DIG)
	if Input.is_action_pressed("thump"):
		finished.emit(THUMP)
	if Input.is_action_pressed("left") or Input.is_action_pressed("right") or Input.is_action_pressed("up") or Input.is_action_pressed("down"):
		finished.emit(MOVE)
	
