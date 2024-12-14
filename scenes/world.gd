extends Node2D


@export var ground_layer : TileMapLayer
@export var dimensions : Vector2i



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(-dimensions.x / 2, dimensions.x / 2):
		for j in range(-dimensions.y / 2, dimensions.y / 2):
			ground_layer.set_cell(Vector2i(i, j), 0, Vector2i(randi_range(0, 5), randi_range(0, 2)))

