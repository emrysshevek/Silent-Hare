
class_name Player extends Animal

var food = null
var what_area = 2 
var score = 0

func _physics_process(_delta: float) -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	move_and_slide()
	
	if what_area == 1:
		if Input.is_action_just_pressed("Dig"):
			food.collect()
			score += 1


func _on_collection_area_area_entered(area:Area2D) -> void:
	if area.get_parent() is Food:
		food  = area.get_parent()
		what_area = 1

func _on_collection_area_area_exited(area):
	what_area = 2
