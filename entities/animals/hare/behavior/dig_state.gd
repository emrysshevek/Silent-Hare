class_name DigState extends PlayerState


func enter(_prev_state_path: String, _data := {}):

	if player.what_area == 1:
		player.food.collect()
		player.score += 1
	get_tree().create_timer(.5).timeout.connect(on_timer_timeout)

func on_timer_timeout() -> void:
	finished.emit(IDLE)
