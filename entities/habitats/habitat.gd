class_name Habitat extends Node2D

@export var spawner: Spawner

@export_group("Ranges")
@export var base_range: float = 32
@export var wander_range: float = 32
@export var chase_range: float = 64

@onready var base_area: Area2D = get_node_or_null("BaseArea")
@onready var wander_area: Area2D = get_node_or_null("WanderArea")
@onready var chase_area: Area2D = get_node_or_null("ChaseArea")

enum HabitatRangeType {
	BASE,
	WANDER,
	CHASE
}

var inhabitants: Array[Animal] = []

func _ready() -> void:
	wander_range = wander_range if wander_range > 0 else base_range
	chase_range = chase_range if chase_range > 0 else base_range

	base_area.get_node("CollisionShape2D").shape.radius = base_range
	wander_area.get_node("CollisionShape2D").shape.radius = wander_range
	chase_area.get_node("CollisionShape2D").shape.radius = chase_range

	if spawner:
		spawner.spawned.connect(_on_spawner_spawned)

func _on_spawner_spawned(animal: Animal) -> void:
	inhabitants.append(animal)
	animal.home = self


func _on_base_area_body_entered(body:Node2D) -> void:
	var animal := body as Animal
	if animal and animal in inhabitants:
		animal.on_entered_habitat_range(self, HabitatRangeType.BASE)

func _on_base_area_body_exited(body:Node2D) -> void:
	var animal := body as Animal
	if animal and animal in inhabitants:
		animal.on_exited_habitat_range(self, HabitatRangeType.BASE)

func _on_wander_area_body_entered(body:Node2D) -> void:
	var animal := body as Animal
	if animal and animal in inhabitants:
		animal.on_entered_habitat_range(self, HabitatRangeType.WANDER)


func _on_wander_area_body_exited(body:Node2D) -> void:
	var animal := body as Animal
	if animal and animal in inhabitants:
		animal.on_exited_habitat_range(self, HabitatRangeType.WANDER)

func _on_chase_area_body_entered(body:Node2D) -> void:
	var animal := body as Animal
	if animal and animal in inhabitants:
		animal.on_entered_habitat_range(self, HabitatRangeType.CHASE)


func _on_chase_area_body_exited(body:Node2D) -> void:
	var animal := body as Animal
	if animal and animal in inhabitants:
		animal.on_exited_habitat_range(self, HabitatRangeType.CHASE)
