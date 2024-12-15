class_name Food
extends Node2D

signal collected()

func collect():
	collected.emit()
	queue_free()
