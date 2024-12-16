class_name Player extends Animal


func _physics_process(_delta: float) -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	move_and_slide()

func _on_area_2d_area_entered(area:Area2D) -> void:
	var food : Food = area.get_parent()
	food.collect()
