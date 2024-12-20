class_name Chunk extends Node2D

@onready var snow_scene = load("res://entities/items/snow.tscn")

var coords: Vector2i
var food: Dictionary

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
	# var noise: int = posmod(int(NoiseMaps.biome.get_noise_2d(tile_pos.x, tile_pos.y) *  pow(10, 7)), 10)
	var noise = TerrainMaps.biome.get_noise_2d(tile_pos.x, tile_pos.y)
	if noise < .4:
		generate_snow_tile(x, y)
	else:
		generate_forest_tile(x, y)

func generate_snow_tile(x: int, y: int) -> void:
	pass

func generate_rock_field_tile(x: int, y: int) -> void:
	var rock: Sprite2D = load("res://entities/items/rock.tscn").instantiate()
	add_child(rock)
	var jitter = Vector2(randf_range(0, 32), randf_range(0, 32))
	rock.position = Constants.tile_to_position(Vector2i(x, y)) + jitter

func generate_forest_tile(x: int, y: int) -> void:
	var tree: Sprite2D = load("res://entities/items/tree.tscn").instantiate()
	add_child(tree)
	var jitter = Vector2(randf_range(0, 32), randf_range(0, 32))
	tree.position = Constants.tile_to_position(Vector2i(x, y)) + jitter
	tree.rotation += deg_to_rad(randf_range(-2, 2))
