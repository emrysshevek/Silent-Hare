class_name Animal
extends CharacterBody2D

signal animal_entered_vision(which_animal : Animal)
signal animal_exited_vision(which_animal : Animal)
signal animal_entered_hearing(which_animal : Animal)
signal animal_exited_hearing(which_animal : Animal)

@export var speed : float = 50
@export var vision_range : float = 16
@export var hearing_range : float = 16
@export var visible_range : float = 16
@export var hearable_range : float = 16

@onready var vision : SenseArea = get_node_or_null("VisionRange")
@onready var hearing : SenseArea = get_node_or_null("HearingRange")

func _ready() -> void:
	if vision:
		vision.set_radius(vision_range)
	if hearing:
		hearing.set_radius(hearing_range)


func on_animal_entered_range(sense: SenseArea, animal: Animal) -> void:
	if sense == vision:
		animal_entered_vision.emit(animal)
	elif sense == hearing:
		animal_entered_hearing.emit(animal)

func on_animal_exited_range(sense: SenseArea, animal: Animal) -> void:
	if sense == vision:
		animal_exited_vision.emit(animal)
	elif sense == hearing:
		animal_exited_hearing.emit(animal)
