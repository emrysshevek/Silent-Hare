extends Node2D

@export var chunk_size := 8

@onready var player := $Player

var tile_size = 32
var chunks: Array[Chunk]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	BackgroundMusicManager.crossfade_to(BackgroundMusicManager.BackgroundTrack.PEACE)
	# var curr_chunk := cell_to_chunk(position_to_chunk(player.global_position))
	for i in range(-1, 2):
		for j in range(-1, 2):
			var chunk: Chunk = load("res://scenes/world/chunk.tscn").instantiate()
			add_child(chunk)
			chunk.generate(Vector2i(i, j))

func cell_to_chunk(cell: Vector2i) -> Vector2i:
	return Vector2i(cell.x / chunk_size, cell.y / chunk_size)

func position_to_chunk(pos: Vector2) -> Vector2i:
	#todo: tilesize magic number
	return Vector2i(floor(pos.x / (chunk_size * tile_size)), floor(pos.y / (chunk_size * tile_size)))


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			# zoom in
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				get_node("Camera2D").zoom *= 1.1				
			# zoom out
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				get_node("Camera2D").zoom /= 1.1