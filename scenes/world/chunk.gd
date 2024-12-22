class_name Chunk extends Node2D

@onready var snow_scene = load("res://entities/items/snow.tscn")
@onready var tree_scene = load("res://entities/items/tree.tscn")
@onready var rock_scene = load("res://entities/items/rock.tscn")
@onready var food_scene = load("res://entities/items/food.tscn")
@onready var fox_den_scene = load("res://entities/habitats/fox_den.tscn")

var save_root = "res://save_data/world/"
var chunk_data = preload("res://scenes/world/chunk_data.tres")
var coords: Vector2i
var food_locations: Array[Food]
var den_location = null
var terrains: Dictionary

func _exit_tree() -> void:
	save_chunk_data()

func generate(at: Vector2i) -> void:
	coords = at
	chunk_data.coords = at
	global_position = Constants.chunk_to_global(chunk_data.coords)

	if generate_from_save():
		return
	
	for i in range(Constants.CHUNK_SIZE):
		for j in range(Constants.CHUNK_SIZE):
			generate_biome(i, j)

	if chunk_data.coords != Vector2i.ZERO and TerrainMaps.fox_distribution.get_noise_2d(chunk_data.coords.x, chunk_data.coords.y) < 0:
		spawn_den()

func generate_from_save() -> bool:
	var loaded_data = load_chunk_data()
	if loaded_data == null:
		return false

	chunk_data = loaded_data
	for pos in chunk_data.tiles.keys():
		var tile = chunk_data.tiles[pos]
		if tile.tree != null:
			spawn_tree(pos)
		elif tile.rock != null:
			spawn_rock(pos)
	for pos in chunk_data.food_locations:
		spawn_food(pos)
	if chunk_data.den_location != Vector2.INF:
		spawn_den()

	return true

func center() -> Vector2:
	return global_position * Constants.CHUNK_SIZE * Constants.TILE_SIZE

func generate_biome(x: int, y: int) -> void:
	var tile_contents = preload("res://scenes/world/tile_contents.tres")
	var tile_pos = Constants.tile_to_global(Vector2i(x, y), chunk_data.coords)
	var biome_noise = TerrainMaps.biome.get_noise_2d(tile_pos.x, tile_pos.y)

	if biome_noise < .6:
		terrains[Vector2(x, y)] = World.Biome.SNOW
		populate_snow_tile(tile_pos, tile_contents)
	else:
		terrains[Vector2(x, y)] = World.Biome.FOREST
		populate_forest_tile(tile_pos, tile_contents)

	chunk_data.tiles[Vector2(tile_pos)] = tile_contents

	var food_noise = TerrainMaps.food_distribution.get_noise_2d(tile_pos.x, tile_pos.y)
	var rng = rand_from_seed(food_noise * 10000)[0] / float(2 ** 32)
	food_noise = remap_range(food_noise, 0, 1) * .7 - .4
	if rng < max(food_noise, 0.025):
		spawn_food(tile_pos, chunk_data)

func spawn_den(pos := Vector2.INF) -> void:
	var den = fox_den_scene.instantiate() as Node2D
	add_child(den)
	if pos != Vector2.INF:
		den.position = pos
	else:
		var jitter = Vector2(randf_range(0, Constants.CHUNK_SIZE * Constants.TILE_SIZE), randf_range(0, Constants.CHUNK_SIZE * Constants.TILE_SIZE))
		den.position += jitter
		chunk_data.den_location = den.position

func remap_range(x: float, out_min: float, out_max: float, in_min:=-1.0, in_max:=1.0):
	return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;

func seeded_randf(x: int) -> float:
	return rand_from_seed(x * 10000)[0] / float(2 ** 32)

func populate_snow_tile(pos: Vector2, tile) -> void:
	if remap_range(TerrainMaps.rock_distribution.get_noise_2d(pos.x, pos.y), 0, 1) < .055:
		spawn_rock(pos, tile)
	elif remap_range(TerrainMaps.tree_distribution.get_noise_2d(pos.x, pos.y), 0, 1) < .055:
		spawn_tree(pos, tile)

func populate_forest_tile(pos: Vector2, tile) -> void:
	if remap_range(TerrainMaps.tree_distribution.get_noise_2d(pos.x, pos.y), 0, 1) < .5:
		spawn_tree(pos, tile)
	elif remap_range(TerrainMaps.rock_distribution.get_noise_2d(pos.x, pos.y), 0, 1) < .1:
		spawn_rock(pos, tile)

func spawn_food(pos: Vector2, chunk = null) -> void:
	var food: Food = food_scene.instantiate()
	add_child(food)
	var jitter = Vector2(randf_range(0, Constants.TILE_SIZE / 2), randf_range(0, Constants.TILE_SIZE / 2))
	food.global_position = pos + jitter
	food.collected.connect(on_food_collected)
	if chunk:
		chunk.food_locations.append(food.global_position)

func spawn_tree(pos: Vector2, tile = null) -> void:
	var tree: Sprite2D = tree_scene.instantiate()
	add_child(tree)
	var jitter = Vector2(randf_range(0, Constants.TILE_SIZE), randf_range(0, Constants.TILE_SIZE))
	tree.global_position = pos + jitter
	tree.rotation += deg_to_rad(randf_range(-2, 2))
	if tile:
		tile.tree = tree.global_position
		
func spawn_rock(pos: Vector2, tile = null) -> void:
	var rock: Sprite2D = rock_scene.instantiate()
	add_child(rock)
	var jitter = Vector2(randf_range(0, Constants.TILE_SIZE), randf_range(0, Constants.TILE_SIZE))
	rock.global_position = pos + jitter
	rock.rotation += deg_to_rad(randf_range(-2, 2))
	if tile:
		tile.rock = rock.global_position

func on_food_collected(which_food: Food) -> void:
	chunk_data.food_locations.erase(which_food.global_position)

func load_chunk_data():
	var save_path = save_root + str(chunk_data.coords.x) + "_" + str(chunk_data.coords.y) + ".tres"
	if ResourceLoader.exists(save_path):
		print("loading chunk: ", coords)
		return ResourceLoader.load(save_path)
	return null

func save_chunk_data() -> void:
	print("saving chunk: ", coords)
	var save_path = save_root + str(coords.x) + "_" + str(coords.y) + ".tres"
	ResourceSaver.save(chunk_data, save_path, ResourceSaver.FLAG_BUNDLE_RESOURCES)
