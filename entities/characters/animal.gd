class_name Animal
extends CharacterBody2D

# signal animal_entered_vision(which_animal : Animal)
# signal animal_exited_vision(which_animal : Animal)
# signal animal_entered_hearing(which_animal : Animal)
# signal animal_exited_hearing(which_animal : Animal)

@export var speed : float = 100
@export var vision_range : float = 16
@export var hearing_range : float = 16

@onready var vision_area : SenseArea = get_node("VisionArea")
@onready var hearing_area : SenseArea = get_node("HearingArea")

func _ready() -> void:
	vision_area.set_radius(vision_range)
	hearing_area.set_radius(hearing_range)


func on_animal_entered_range(animal: Animal) -> void:
	pass

func on_animal_exited_range(animal: Animal) -> void:
	pass