extends CharacterBody2D


func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * 50
	move_and_slide()

func _on_area_2d_area_entered(area:Area2D) -> void:
	var food : Food = area.get_parent()
	food.collect()
