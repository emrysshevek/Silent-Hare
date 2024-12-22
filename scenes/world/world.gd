class_name World extends Node2D

@export var chunk_size := 8

@onready var player := $Player

var chunk_data: Dictionary = {}
var active_chunks: Dictionary = {}
var prev_chunk: Vector2i = Vector2i.MAX

var save_root = "res://save_data/world/"

enum Biome {
	SNOW,
	FOREST
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	BackgroundMusicManager.crossfade_to(BackgroundMusicManager.BackgroundTrack.PEACE)
	# prev_chunk = position_to_chunk(player.global_position)


func _process(delta: float) -> void:
	var curr_chunk := position_to_chunk(player.global_position)
	if curr_chunk == prev_chunk:
		return

	# print("entered new chunk: ", curr_chunk)
	prev_chunk = curr_chunk
	for key in active_chunks.keys():
		if abs(active_chunks[key].coords.x - curr_chunk.x) > 1 or abs(active_chunks[key].coords.y - curr_chunk.y) > 1:
			print("unloading chunk: ", key)
			update_chunk_data(active_chunks[key])
			active_chunks[key].queue_free()
			active_chunks.erase(key)

	for i in range(curr_chunk.x - 1, curr_chunk.x + 2):
		for j in range(curr_chunk.y - 1, curr_chunk.y + 2):
			var key = Vector2i(i, j)
			if key not in active_chunks:	
				print("spawning chunk: ", key)
				var chunk = load("res://scenes/world/chunk.tscn").instantiate()
				add_child(chunk)
				if key in chunk_data:
					chunk.food_locations = chunk_data[key]["food"]
					chunk.den_location = chunk_data[key]["den"]
					chunk.hole_locations = chunk_data[key]["holes"]
					chunk.generate(key, false, false)
				else:
					chunk.generate(Vector2i(i, j))
				update_chunk_data(chunk)
				active_chunks[key] = chunk

func update_chunk_data(chunk: Chunk) -> void:
	chunk_data[chunk.coords] = {
		"food": chunk.food_locations,
		"den": chunk.den_location,
		"holes": chunk.hole_locations
	}

func load_saved_chunk(key: Vector2i) -> Chunk:
	var path = save_root + str(key.x) + "_" + str(key.y) + ".tscn"
	if ResourceLoader.exists(path):
		return load(path).instantiate()
	else:
		return null

func add_snow_hole(pos: Vector2) -> void:
	var chunk = active_chunks[position_to_chunk(player.global_position)]
	chunk.spawn_hole(pos)

func cell_to_chunk(cell: Vector2i) -> Vector2i:
	return Vector2i(cell.x / chunk_size, cell.y / chunk_size)

func position_to_chunk(pos: Vector2) -> Vector2i:
	return Vector2i(floor(pos.x / (Constants.CHUNK_SIZE * Constants.TILE_SIZE)), floor(pos.y / (Constants.CHUNK_SIZE * Constants.TILE_SIZE)))

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			# zoom in
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				get_node("Camera2D").zoom *= 1.1				
			# zoom out
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				get_node("Camera2D").zoom /= 1.1
