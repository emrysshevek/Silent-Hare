class_name Chunk extends Node2D

@onready var snow_scene = load("res://entities/items/snow.tscn")
@onready var tree_scene = load("res://entities/items/tree.tscn")
@onready var rock_scene = load("res://entities/items/rock.tscn")
@onready var food_scene = load("res://entities/items/food.tscn")
@onready var fox_den_scene = load("res://entities/habitats/fox_den.tscn")

var coords: Vector2i
var foods: Array[Food]
var den = null
var terrain: Dictionary

func generate(at: Vector2i) -> void:
	coords = at
	global_position = Constants.chunk_to_global(coords)

	for i in range(Constants.CHUNK_SIZE):
		for j in range(Constants.CHUNK_SIZE):
			generate_biome(i, j)

	if coords != Vector2i.ZERO and TerrainMaps.fox_distribution.get_noise_2d(coords.x, coords.y) < 0:
		spawn_den()

func center() -> Vector2:
	return global_position * Constants.CHUNK_SIZE * Constants.TILE_SIZE

func generate_biome(x: int, y: int) -> void:
	var tile_pos = Constants.tile_to_global(Vector2i(x, y), coords)
	var biome_noise = TerrainMaps.biome.get_noise_2d(tile_pos.x, tile_pos.y)

	if biome_noise < .6:
		terrain[Vector2(x, y)] = World.Biome.SNOW
		populate_snow_tile(tile_pos)
	else:
		terrain[Vector2(x, y)] = World.Biome.FOREST
		populate_forest_tile(tile_pos)

	var food_noise = TerrainMaps.food_distribution.get_noise_2d(tile_pos.x, tile_pos.y)
	var rng = rand_from_seed(food_noise * 10000)[0] / float(2 ** 32)
	food_noise = remap_range(food_noise, 0, 1) * .7 - .4
	# print(rng, ", ", food_noise)
	if rng < max(food_noise, 0.025):
		spawn_food(tile_pos)
	

func spawn_den() -> void:
	var den = fox_den_scene.instantiate() as Node2D
	add_child(den)
	var jitter = Vector2(randf_range(0, Constants.CHUNK_SIZE * Constants.TILE_SIZE), randf_range(0, Constants.CHUNK_SIZE * Constants.TILE_SIZE))
	den.position += jitter

func remap_range(x: float, out_min: float, out_max: float, in_min:=-1.0, in_max:=1.0):
	return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;

func seeded_randf(x: int) -> float:
	return rand_from_seed(x * 10000)[0] / float(2 ** 32)

func populate_snow_tile(pos: Vector2) -> void:
	if remap_range(TerrainMaps.rock_distribution.get_noise_2d(pos.x, pos.y), 0, 1) < .055:
		spawn_rock(pos)
	elif remap_range(TerrainMaps.tree_distribution.get_noise_2d(pos.x, pos.y), 0, 1) < .055:
		spawn_tree(pos)

func populate_forest_tile(pos: Vector2) -> void:
	if remap_range(TerrainMaps.tree_distribution.get_noise_2d(pos.x, pos.y), 0, 1) < .5:
		spawn_tree(pos)
	elif remap_range(TerrainMaps.rock_distribution.get_noise_2d(pos.x, pos.y), 0, 1) < .1:
		spawn_rock(pos)

func spawn_food(pos: Vector2) -> void:
	var food: Food = food_scene.instantiate()
	add_child(food)
	var jitter = Vector2(randf_range(0, Constants.TILE_SIZE / 2), randf_range(0, Constants.TILE_SIZE / 2))
	food.global_position = pos + jitter
	food.collected.connect(on_food_collected)
	foods.append(food) 

func spawn_tree(pos: Vector2) -> void:
	var tree: Sprite2D = tree_scene.instantiate()
	add_child(tree)
	var jitter = Vector2(randf_range(0, Constants.TILE_SIZE), randf_range(0, Constants.TILE_SIZE))
	tree.global_position = pos + jitter
	tree.rotation += deg_to_rad(randf_range(-2, 2))

func spawn_rock(pos: Vector2) -> void:
	var rock: Sprite2D = rock_scene.instantiate()
	add_child(rock)
	var jitter = Vector2(randf_range(0, Constants.TILE_SIZE), randf_range(0, Constants.TILE_SIZE))
	rock.global_position = pos + jitter
	rock.rotation += deg_to_rad(randf_range(-2, 2))

func on_food_collected(which_food: Food) -> void:
	foods.erase(which_food)
