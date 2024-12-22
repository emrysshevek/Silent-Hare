class_name SenseArea
extends Area2D

signal animal_entered_sense_range(which_sense : SenseArea, which_animal : Animal)
signal animal_exited_sense_range(which_sense: SenseArea, which_animal : Animal)

@onready var collision : CollisionShape2D = get_node("CollisionShape2D")

func _ready() -> void:
	if not area_entered.is_connected(_on_area_entered):
		area_entered.connect(_on_area_entered)
	if not area_exited.is_connected(_on_area_exited):
		area_exited.connect(_on_area_exited)

func set_radius(radius : float) -> void:
	var shape := CircleShape2D.new()
	shape.radius = radius
	collision.shape = shape

func get_radius() -> float:
	return collision.shape.radius

	
func _on_area_entered(area:Area2D) -> void:
	if area.get_parent() is Animal:
		animal_entered_sense_range.emit(self, area.get_parent())


func _on_area_exited(area:Area2D) -> void:		
	if area.get_parent() is Animal:
		animal_exited_sense_range.emit(self, area.get_parent())

