extends Node


var biome_noise = FastNoiseLite.new()


func _init() -> void:
    biome_noise.noise_type = FastNoiseLite.TYPE_CELLULAR
    biome_noise.CellularReturnType = FastNoiseLite.RETURN_CELL_VALUE
    