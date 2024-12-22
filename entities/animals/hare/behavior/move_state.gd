class_name MoveState extends PlayerState

var sprite: AnimatedSprite2D
var in_motion = false

func enter(_prev_state_path: String, _data := {}):
	sprite = player.get_node("AnimatedSprite2D")
	in_motion = false

func physics_update(delta: float) -> void:
	if in_motion:
		return

	var direction = Input.get_vector("left", "right", "up", "down")
	if direction.x < 0:
		player.sprite.flip_h = true
	elif direction.x > 0:
		player.sprite.flip_h = false

	if Input.is_action_pressed("sprint"):
		var tween = get_tree().create_tween()
		tween.tween_property(player, "position", player.position + (direction * 24), .27)
		tween.set_ease(Tween.EASE_IN)
		tween.set_trans(Tween.TRANS_BACK)
		get_tree().create_timer(.27).timeout.connect(on_timer_timeout)
		sprite.animation = "run"
		sprite.play()
		in_motion = true

		if player.audio.stream != player.run_sound:
			player.audio.stream = player.run_sound
			player.audio.play()
	else:
		var tween = get_tree().create_tween()
		tween.tween_property(player, "position", player.position + (direction * 16), .625)
		tween.set_ease(Tween.EASE_IN)
		tween.set_trans(Tween.TRANS_BACK)
		get_tree().create_timer(.75).timeout.connect(on_timer_timeout)
		sprite.animation = "walk"
		sprite.play()
		in_motion = true

		if player.audio.stream != player.walk_sound:
			player.audio.stream = player.walk_sound
			player.audio.play()

func on_timer_timeout() -> void:
	in_motion = false
	finished.emit(IDLE)
