class_name ThumpState extends PlayerState

var thump_component = null

func enter(_prev_state_path: String, _data := {}):
	if thump_component == null:
		thump_component = player.get_node("thump")
		print("thump component: ", thump_component)

	thump_component.thump()
	player.sprite.animation = "thump"
	player.sprite.play()
	get_tree().create_timer(.5).timeout.connect(on_timer_timeout)

func on_timer_timeout() -> void:
	finished.emit(IDLE)
