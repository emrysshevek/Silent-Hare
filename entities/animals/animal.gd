class_name Animal
extends CharacterBody2D

signal animal_entered_vision(which_animal : Animal)
signal animal_exited_vision(which_animal : Animal)
signal animal_entered_hearing(which_animal : Animal)
signal animal_exited_hearing(which_animal : Animal)

@export var walk_speed : float = 25
@export var run_speed : float = 50
@export var turn_speed: float = 30

@export var vision_range : float = 16
@export var hearing_range : float = 16
@export var visible_range : float = 16
@export var hearable_range : float = 16

@onready var vision : SenseArea = get_node_or_null("VisionArea")
@onready var hearing : SenseArea = get_node_or_null("HearingArea")

@onready var sprite: AnimatedSprite2D = get_node("AnimatedSprite2D")

var walk_sound: AudioStream = preload("res://assets/sounds/Walk.mp3")
var run_sound: AudioStream = preload("res://assets/sounds/Run.mp3")

var prey_in_vision: Animal = null
var prey_in_hearing: Animal = null

var in_base_area := false
var in_wander_area := false
var in_chase_area := false

var home: Habitat

func _ready() -> void:
	if vision:
		vision.set_radius(vision_range)
		if not vision.animal_entered_sense_range.is_connected(on_animal_entered_range):
			vision.animal_entered_sense_range.connect(on_animal_entered_range)
		if not vision.animal_exited_sense_range.is_connected(on_animal_exited_range):
			vision.animal_exited_sense_range.connect(on_animal_exited_range)
	if hearing:
		hearing.set_radius(hearing_range)
		if not hearing.animal_entered_sense_range.is_connected(on_animal_entered_range):
			hearing.animal_entered_sense_range.connect(on_animal_entered_range)
		if not hearing.animal_exited_sense_range.is_connected(on_animal_exited_range):
			hearing.animal_exited_sense_range.connect(on_animal_exited_range)

func _physics_process(_delta: float) -> void:
	move_and_slide()

func on_animal_entered_range(sense: SenseArea, animal: Animal) -> void:
	if not animal is Player:
		return

	print("animal entered range")
	if sense == vision:
		prey_in_vision = animal
		animal_entered_vision.emit(animal)
	elif sense == hearing:
		prey_in_hearing = animal
		animal_entered_hearing.emit(animal)

func on_animal_exited_range(sense: SenseArea, animal: Animal) -> void:
	print("animal exited range")
	if sense == vision:
		prey_in_vision = null if animal == prey_in_vision else prey_in_vision
		animal_exited_vision.emit(animal)
	elif sense == hearing:
		prey_in_hearing = null if animal == prey_in_hearing else prey_in_hearing
		animal_exited_hearing.emit(animal)

func on_exited_habitat_range(habitat: Habitat, type: Habitat.HabitatRangeType) -> void:
	if habitat != home:
		return
	# print("exited habitat")

	if type == Habitat.HabitatRangeType.BASE:
		in_base_area = false
	if type == Habitat.HabitatRangeType.WANDER:
		in_wander_area = false
	if type == Habitat.HabitatRangeType.CHASE:
		in_chase_area = false

func on_entered_habitat_range(habitat: Habitat, type: Habitat.HabitatRangeType) -> void:
	if habitat != home:
		return
	# print("entered habitat")

	if type == Habitat.HabitatRangeType.BASE:
		in_base_area = true
	if type == Habitat.HabitatRangeType.WANDER:
		in_wander_area = true
	if type == Habitat.HabitatRangeType.CHASE:
		in_chase_area = true