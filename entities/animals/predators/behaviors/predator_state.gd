class_name PredatorState extends State

const HOME := "Home"
const WANDER := "Wander"
const CHASE := "Chase"
const RETURN := "Return"

var animal: Animal

func _ready() -> void:
	await owner.ready
	animal = owner as Animal
	assert(animal != null, "The Predator state type must be used only in the animal scene. It needs the owner to be a Animal node.")

