extends PredatorState

@export var stamina := 5.0
@export var patience := 25.0
@export var recovery := 2

const CHASING = "Chasing"
const RESTING = "Resting"
const SEARCHING = "Searching"

var prey: Animal
var target: Vector2
var search_radius: float = 64
var search_target: Vector2 = Vector2.INF
var acceleration = Vector2.ZERO
var remaining_stamina: float
var remaining_patience: float
var remaining_recovery: float
var state: String

func enter(_prev_state_path: String, _data := {}):
	prey = animal.prey_in_vision if animal.prey_in_vision else animal.prey_in_hearing
	target = prey.global_position

	remaining_stamina = stamina
	remaining_patience = patience
	remaining_recovery = recovery

	search_target = Vector2.INF

	state = CHASING

func physics_update(delta: float) -> void:
	remaining_patience -= delta
	if remaining_patience <= 0:
		finished.emit(HOME)
		return

	prey = animal.prey_in_vision if animal.prey_in_vision else animal.prey_in_hearing

	if state == RESTING:
		handle_resting_state(delta)
	elif state == CHASING:
		handle_chasing_state(delta)
	elif state == SEARCHING:
		handle_searching_state(delta)

func handle_resting_state(delta: float) -> void:
	animal.velocity *= .85

	remaining_recovery -= delta
	if remaining_recovery <= 0:
		remaining_recovery = recovery
		if not prey:
			state = SEARCHING
			return
		remaining_stamina = stamina
		state = CHASING

	# remaining_stamina = min(remaining_stamina + (stamina * delta), stamina)
	# if remaining_stamina == stamina:
	# 	state = CHASING

func handle_chasing_state(delta: float) -> void:
	remaining_stamina -= delta
	if remaining_stamina <= 0:
		state = RESTING
		return

	if prey:
		target = prey.global_position

	if animal.global_position.distance_to(target) < 8:
		state = RESTING
		return
	
	acceleration += seek()
	animal.velocity += acceleration * delta
	animal.velocity = animal.velocity.limit_length(animal.run_speed)

func seek():
	var steer = Vector2.ZERO
	if target:
		var desired = (target - animal.global_position).normalized() * animal.run_speed
		steer = (desired - animal.velocity).normalized() * animal.turn_speed
	return steer

func handle_searching_state(_delta) -> void:
	if search_target == Vector2.INF:
		search_target = target + Vector2(randf_range(-search_radius, search_radius), randf_range(-search_radius, search_radius))

	if animal.global_position.distance_to(search_target) < 8:
		print("searched ", search_target)
		search_target = Vector2.INF
		state = RESTING
		return
	
	animal.velocity = animal.global_position.direction_to(search_target) * animal.walk_speed

