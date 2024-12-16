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

var animal_in_vision := false
var animal_in_hearing := false
var in_base_area := false
var in_wander_area := false
var in_chase_area := false

var home: Habitat

func _ready() -> void:
	if vision:
		vision.set_radius(vision_range)
	if hearing:
		hearing.set_radius(hearing_range)

const IDLE = "idle"
const CHASE = "chase"
const RETURN = "return"

var state := IDLE
var wait_time := .5
var target : Vector2 = Vector2.INF

func _physics_process(delta: float) -> void:

	# if state == IDLE:
	# 	_process_idle_state(delta)

	move_and_slide()


func _process_idle_state(delta: float) -> void:
	wait_time -= delta

	if wait_time > 0:
		velocity = Vector2.ZERO 
		return
	
	if global_position.distance_to(target) < 1:
		target = Vector2.INF
		wait_time = randf_range(.5, 1)
		return

	if target == Vector2.INF:
		target = global_position + Vector2(randf_range(-48, 48), randf_range(-48, 48))
		
	var dir := global_position.direction_to(target)
	velocity = dir * speed

func on_animal_entered_range(sense: SenseArea, animal: Animal) -> void:
	if sense == vision:
		animal_in_vision = true
		animal_entered_vision.emit(animal)
	elif sense == hearing:
		animal_in_vision = true
		animal_entered_hearing.emit(animal)

func on_animal_exited_range(sense: SenseArea, animal: Animal) -> void:
	if sense == vision:
		animal_in_vision = false
		animal_exited_vision.emit(animal)
	elif sense == hearing:
		animal_in_vision = false
		animal_exited_hearing.emit(animal)

func on_exited_habitat_range(habitat: Habitat, type: Habitat.HabitatRangeType) -> void:
	if habitat != home:
		return

	if type == Habitat.HabitatRangeType.BASE:
		in_base_area = false
	if type == Habitat.HabitatRangeType.WANDER:
		in_wander_area = false
	if type == Habitat.HabitatRangeType.CHASE:
		in_chase_area = false

func on_entered_habitat_range(habitat: Habitat, type: Habitat.HabitatRangeType) -> void:
	if habitat != home:
		return

	if type == Habitat.HabitatRangeType.BASE:
		in_base_area = true
	if type == Habitat.HabitatRangeType.WANDER:
		in_wander_area = true
	if type == Habitat.HabitatRangeType.CHASE:
		in_chase_area = true