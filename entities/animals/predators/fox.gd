extends Animal

const IDLE = "idle"
const CHASE = "chase"
const RETURN = "return"

var state := IDLE
var wait_time := .5
var target : Vector2 = Vector2.INF

func _physics_process(delta: float) -> void:

	if state == IDLE:
		_process_idle_state(delta)

	move_and_slide()


func _process_idle_state(delta: float) -> void:
	wait_time -= delta

	if wait_time > 0:
		velocity = Vector2.ZERO 
		return
	
	if global_position.distance_to(target) < 1:
		target = Vector2.INF
		wait_time = randf_range(.5, 1)
		return

	if target == Vector2.INF:
		target = global_position + Vector2(randf_range(-48, 48), randf_range(-48, 48))
		
	var dir := global_position.direction_to(target)
	velocity = dir * speed

	
