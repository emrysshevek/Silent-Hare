class_name HomeState extends PredatorState

@export var min_duration := 5.0
@export var max_duration := 15.0

# func enter(prev_state_path: String, data := {}):
# 	print("entered home state")

func physics_update(_delta: float) -> void:
	if animal.global_position.distance_to(animal.home.global_position) > 2:
		animal.velocity = animal.global_position.direction_to(animal.home.global_position) * animal.walk_speed
	elif animal.visible:
		animal.hide()
		animal.velocity = Vector2.ZERO
		var timer = get_tree().create_timer(randf_range(min_duration, max_duration))
		timer.timeout.connect(finish_stay)

func exit() -> void:
	animal.global_position = animal.home.global_position
	animal.velocity = Vector2.ZERO
	animal.show()

func finish_stay() -> void:
	print("finished stay")
	finished.emit(WANDER)
