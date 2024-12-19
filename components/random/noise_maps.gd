extends Node

var biome = FastNoiseLite.new()


func _init() -> void:
    biome.offset = Vector3(randi_range(-1000, 1000), randi_range(-1000, 1000), 0)
    biome.noise_type = FastNoiseLite.TYPE_CELLULAR
    biome.cellular_return_type = FastNoiseLite.RETURN_CELL_VALUE
    biome.frequency = .005
    biome.cellular_jitter = 2
    biome.fractal_type = FastNoiseLite.FRACTAL_NONE

	
