extends PredatorState

var prey: Animal
var target: Vector2
var in_range = false

func enter(prev_state_path: String, data := {}):
	# if not animal.is_connected(""
	prey = data['prey']
	target = prey.global_position
	in_range = true

func physics_update(delta: float) -> void:
	
	if in_range:
		target = prey.global_position
	
	animal.velocity = animal.global_position.direction_to(target) * animal.speed * 2
	
	
