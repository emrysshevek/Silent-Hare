
class_name Player extends Animal

signal died()

@onready var hearable: SenseArea = get_node("HearableArea")

var food = null
var what_area = 2 
var score = 0

var walk_sound: AudioStream = preload("res://assets/sounds/Hair/Hair Walk.mp3")
var run_sound: AudioStream = preload("res://assets/sounds/Hair/Hair Run.mp3")
var dig_sound: AudioStream = preload("res://assets/sounds/Hair/Dig.mp3")
var thump_sound: AudioStream = preload("res://assets/sounds/Hair/Thump.mp3")
var thump_success_sound: AudioStream = preload("res://assets/sounds/Hair/Thump if founds.mp3")

func _physics_process(_delta: float) -> void:
	move_and_slide()


func _on_collection_area_area_entered(area:Area2D) -> void:
	if area.get_parent() is Food:
		food = area.get_parent()
		what_area = 1

func _on_collection_area_area_exited(area):
	what_area = 2
	food = null

func _on_hearing_area_animal_entered_sense_range(which_sense: SenseArea, which_animal: Animal) -> void:
	if which_animal is Player:
		return
	
	print("animal entered player range")
	BackgroundMusicManager.crossfade_to(BackgroundMusicManager.BackgroundTrack.CLOSE)

func _on_hearing_area_animal_exited_sense_range(which_sense: SenseArea, which_animal: Animal) -> void:
	if which_animal is Player:
		return
	
	print("animal entered player range")
	BackgroundMusicManager.crossfade_to(BackgroundMusicManager.BackgroundTrack.PEACE)

func kill() -> void:
	died.emit()
	queue_free()
