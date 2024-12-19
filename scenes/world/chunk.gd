class_name Chunk extends Node2D

@onready var ground_layer := $GroundLayer

var coords: Vector2i
var food: Dictionary

func generate(at: Vector2i) -> void:
	coords = at
	global_position = Constants.chunk_to_position(coords)

	for i in range(Constants.CHUNK_SIZE):
		for j in range(Constants.CHUNK_SIZE):
			generate_biome()
			generate_

	


func center() -> Vector2:
	return global_position * Constants.CHUNK_SIZE * Constants.TILE_SIZE
