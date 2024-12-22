class_name Food
extends Node2D

signal collected(which_food: Food)

func collect():
	collected.emit(self)
	var ap = $AnimationPlayer
	ap.play("collect")
	ap.animation_finished.connect(on_animation_finished)
	
func on_animation_finished(name) -> void:
	queue_free()
