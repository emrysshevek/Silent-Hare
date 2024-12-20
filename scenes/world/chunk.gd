class_name Chunk extends Node2D

@onready var snow_scene = load("res://entities/items/snow.tscn")
@onready var tree_scene = load("res://entities/items/tree.tscn")
@onready var rock_scene = load("res://entities/items/rock.tscn")
@onready var food_scene = load("res://entities/items/food.tscn")

var coords: Vector2i
var food: Dictionary
var terrain: Dictionary

func generate(at: Vector2i) -> void:
	coords = at
	global_position = Constants.chunk_to_global(coords)

	for i in range(Constants.CHUNK_SIZE):
		for j in range(Constants.CHUNK_SIZE):
			generate_biome(i, j)

func center() -> Vector2:
	return global_position * Constants.CHUNK_SIZE * Constants.TILE_SIZE

func generate_biome(x: int, y: int) -> void:
	var tile_pos = Constants.tile_to_global(Vector2i(x, y), coords)
	var biome_noise = TerrainMaps.biome.get_noise_2d(tile_pos.x, tile_pos.y)

	# if noise < .5:
	# 	terrain[Vector2(x, y)] = World.Biome.SNOW
	# 	populate_snow_tile(tile_pos)
	# else:
	# 	terrain[Vector2(x, y)] = World.Biome.FOREST
	# 	populate_forest_tile(tile_pos)

	var food_noise = TerrainMaps.food_distribution.get_noise_2d(tile_pos.x, tile_pos.y)
	var rng = float(rand_from_seed(food_noise * 10000)[0]) / (2 ** 32)
	food_noise = remap_range(food_noise, -1, .5)
	if rng < clamp(food_noise, .02, .5):
		spawn_food(tile_pos)

func remap_range(x: float, out_min: float, out_max: float, in_min:=-1.0, in_max:=1.0):
	return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;

func populate_snow_tile(pos: Vector2) -> void:
	pass

func populate_forest_tile(pos: Vector2) -> void:
	spawn_tree(pos)

func spawn_food(pos: Vector2) -> void:
	var tree: Node2D = food_scene.instantiate()
	add_child(tree)
	var jitter = Vector2(randf_range(0, 32), randf_range(0, 32))
	tree.global_position = pos + jitter
	tree.rotation += deg_to_rad(randf_range(-2, 2))

func spawn_tree(pos: Vector2) -> void:
	var tree: Sprite2D = tree_scene.instantiate()
	add_child(tree)
	var jitter = Vector2(randf_range(0, 32), randf_range(0, 32))
	tree.global_position = pos + jitter
	tree.rotation += deg_to_rad(randf_range(-2, 2))
