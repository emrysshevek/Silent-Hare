extends Node

const TILE_SIZE = 32
const CHUNK_SIZE = 8

func position_to_tile(position: Vector2) -> Vector2i:
	return Vector2i(floor(position.x / (CHUNK_SIZE * TILE_SIZE)), floor(position.y / (CHUNK_SIZE * TILE_SIZE)))

func position_to_chunk(position: Vector2) -> Vector2i:
	return Vector2i(floor(position.x / CHUNK_SIZE), floor(position.y / CHUNK_SIZE))

func chunk_to_position(chunk: Vector2i) -> Vector2:
	return chunk * CHUNK_SIZE * TILE_SIZE

func tile_to_position(tile: Vector2i, chunk: Vector2i) -> Vector2:
	return chunk_to_position(chunk) + Vector2(tile * TILE_SIZE) + Vector2(TILE_SIZE / 2.0, TILE_SIZE / 2.0)