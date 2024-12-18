extends Node2D


@export var ground_layer : TileMapLayer
@export var dimensions : Vector2i
@export var food_scene : PackedScene
@export var fox_den_scene : PackedScene
@export var habitat_frequency: float = .1
@export var habitat_jitter: int = 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	BackgroundMusicManager.crossfade_to(BackgroundMusicManager.BackgroundTrack.PEACE)
	
	for i in range(-dimensions.x / 2, dimensions.x / 2):
		for j in range(-dimensions.y / 2, dimensions.y / 2):
			ground_layer.set_cell(Vector2i(i, j), 1 if randf() < .05 else 0, Vector2i.ZERO)
			try_spawn_food(i, j)
	spawn_habitats()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			# zoom in
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				get_node("Camera2D").zoom *= 1.5				
			# zoom out
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				get_node("Camera2D").zoom /= 1.5
	
func try_spawn_food(x: int, y: int) -> void:
	if randf() > .95:
		var food : Node2D = food_scene.instantiate() 
		add_child(food)
		food.position = ground_layer.map_to_local(Vector2i(x, y))

func spawn_habitats() -> void:
	var step_size: Vector2i = dimensions * habitat_frequency
	for i in range(-dimensions.x / 2, dimensions.x / 2 - step_size.x, step_size.x):
		for j in range(-dimensions.y / 2, dimensions.y / 2 - step_size.y, step_size.y):
			# var pos = ground_layer.map_to_local(Vector2i(i + randi_range(0, step_size.x), j + randi_range(0, step_size.y)))
			var pos = (step_size / 2) + Vector2i(i, j)
			var offset = Vector2(randi_range(-habitat_jitter , habitat_jitter), randi_range(-habitat_jitter , habitat_jitter))
			pos = ground_layer.map_to_local(pos) + offset
			
			if pos.distance_to(Vector2i.ZERO) > 128:
				var den = fox_den_scene.instantiate() as Node2D
				add_child(den)
				den.position = pos





