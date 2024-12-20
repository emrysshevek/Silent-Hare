class_name NoiseMaps extends Node

@export var biome: FastNoiseLite
@export var food_distribution: FastNoiseLite

func _ready():
    biome.offset = Vector3(randf_range(-1000, 1000), randf_range(-1000, 1000), 0)
    food_distribution.offset = Vector3(randf_range(-1000, 1000), randf_range(-1000, 1000), 0)
