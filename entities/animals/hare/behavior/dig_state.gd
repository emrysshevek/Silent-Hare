class_name DigState extends PlayerState

var spray_count = 0
var particles: CPUParticles2D

func enter(_prev_state_path: String, _data := {}):
	spray_count = 0
	player.sprite.animation = "hide"
	player.sprite.play()
	player.hearable.set_radius(player.hearable_range * 3)

	particles = player.get_node("CPUParticles2D")
	particles.emitting = true
	get_tree().create_timer(particles.lifetime).timeout.connect(on_timer_timeout)

	if player.what_area == 1:
		player.food.collect()
		player.score += 1
		player.score_changed.emit()
	
	if not player.audio.playing or player.audio.stream != player.dig_sound:
		player.audio.stream = player.dig_sound
		player.audio.play()


func on_timer_timeout() -> void:
	spray_count += 1
	if spray_count == 3:
		var world: World = player.get_parent()
		world.add_snow_hole(player.global_position)
		finished.emit(IDLE)
		return

	particles.emitting = true
	get_tree().create_timer(particles.lifetime).timeout.connect(on_timer_timeout)
