extends Animal

var walking = true
var wait_time = 3
var direction = Vector2.ZERO

func _physics_process(delta: float) -> void:

	wait_time -= delta

	if wait_time <= 0:
		walking = !walking
		if walking:
			direction = Vector2(randf_range(-1,1), randf_range(-1,1))
		wait_time = randf_range(1, 4)


	if !walking:
		velocity = Vector2.ZERO
	else:
		velocity = direction * speed

	move_and_slide()