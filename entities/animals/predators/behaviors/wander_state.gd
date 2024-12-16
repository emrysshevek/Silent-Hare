class_name WanderState extends PredatorState

@export var min_walk_dist := 16
@export var max_walk_dist := 48

var walking = false
var wait_time = 0
var target: Vector2

func enter(prev_state_path: String, data := {}):
    walking = false
    wait_time = 1

func physics_update(delta: float) -> void:
    wait_time -= delta
    if wait_time <= 0 and not walking:
        if randf() < .15:
            finished.emit(HOME)
        walking = true
        target = choose_target()

    if not walking:
        return

    if animal.global_position.distance_to(target) < 2:
        walking = false
        wait_time = randf_range(1, 2)
        animal.velocity = Vector2.ZERO
    else:
        animal.velocity = animal.global_position.direction_to(target) * animal.speed

func choose_target() -> Vector2:
    if animal.in_wander_area:
        var x_offset = randf_range(min_walk_dist, max_walk_dist) * pow(-1, randi_range(0,1))
        var y_offset = randf_range(min_walk_dist, max_walk_dist) * pow(-1, randi_range(0,1))
        return animal.global_position + Vector2(x_offset, y_offset)
    else:
        return animal.global_position + (animal.global_position.direction_to(animal.home.global_position) * max_walk_dist)