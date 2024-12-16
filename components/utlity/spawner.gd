class_name Spawner extends Node2D

signal spawned(node)
signal finished()

@export_group("Spawning")
@export var spawn_count_min: int = 1
@export var spawn_count_max: int = -1
@export var spawn_delay: float = 0
@export var scene : PackedScene

@onready var timer : Timer = get_node_or_null("DelayTimer")


func _ready() -> void:
	spawn_count_max = spawn_count_max if spawn_count_max > 0 else spawn_count_min
	
	if spawn_delay > 0:
		timer.wait_time = spawn_delay
		timer.start()
	else:
		spawn()

func spawn() -> void:
	for i in range(spawn_count_min, spawn_count_max + 1):
		var node = scene.instantiate()
		add_child(node)
		spawned.emit(node)
	finished.emit()
		
func restart() -> void:
	timer.wait_time = spawn_delay
	timer.start()
