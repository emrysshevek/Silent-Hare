class_name HideState extends PlayerState

func enter(_prev_state_path: String, _data := {}):
	player.hearable.set_radius(0)
	
	player.sprite.animation = "hide"
	player.sprite.play()

func physics_update(delta: float) -> void:
	if Input.is_action_just_released("hide"):
		finished.emit(IDLE)
