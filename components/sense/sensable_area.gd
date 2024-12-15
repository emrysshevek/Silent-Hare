class_name SensableArea
extends Area2D

signal entered_sense_range(which_animal : Animal)
signal exited_sense_range(which_animal : Animal)

@onready var collision : CollisionShape2D = get_node("CollisionShape2D")

func set_radius(radius : float) -> void:
	var shape : CircleShape2D = collision.shape
	shape.radius = radius

func get_radius() -> float:
	return collision.shape.radius

	
func _on_area_entered(area:Area2D) -> void:
	if area.get_parent() is Animal:
		entered_sense_range.emit(area.get_parent())


func _on_area_exited(area:Area2D) -> void:		
	if area.get_parent() is Animal:
		exited_sense_range.emit(area.get_parent())