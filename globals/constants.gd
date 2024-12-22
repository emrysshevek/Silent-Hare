extends Node

const TILE_SIZE := 16
const TILE_CENTER := Vector2(16, 16)
const CHUNK_SIZE := 32

func position_to_tile(position: Vector2) -> Vector2i:
	return Vector2i(floor(position.x / (CHUNK_SIZE * TILE_SIZE)), floor(position.y / (CHUNK_SIZE * TILE_SIZE)))

func position_to_chunk(position: Vector2) -> Vector2i:
	return Vector2i(floor(position.x / CHUNK_SIZE), floor(position.y / CHUNK_SIZE))

func chunk_to_global(chunk: Vector2i) -> Vector2:
	return chunk * CHUNK_SIZE * TILE_SIZE

func tile_to_global(tile: Vector2i, chunk: Vector2i) -> Vector2:
	return chunk_to_global(chunk) + Vector2(tile * TILE_SIZE)

func tile_to_position(tile: Vector2i) -> Vector2:
	return tile * TILE_SIZE
