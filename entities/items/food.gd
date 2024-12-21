class_name Food
extends Node2D

signal collected(which_food: Food)

func collect():
	collected.emit(self)
	queue_free()
