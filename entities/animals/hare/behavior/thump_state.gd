class_name ThumpState extends PlayerState

var thump_component = null

func enter(_prev_state_path: String, _data := {}):
	player.stamina -= .5
	player.hearable.set_radius(player.hearable_range * 3)

	if thump_component == null:
		thump_component = player.get_node("thump")
		print("thump component: ", thump_component)

	thump_component.thump()
	player.sprite.animation = "thump"
	player.sprite.play()
	player.audio.stream = player.thump_sound
	player.audio.play()
	get_tree().create_timer(.5).timeout.connect(on_timer_timeout)

func on_timer_timeout() -> void:
	finished.emit(IDLE)
