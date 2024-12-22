
class_name Player extends Animal

signal died()
signal score_changed()
signal returned()

@onready var hearable: SenseArea = get_node("HearableArea")

var food = null
var what_area = 2 
var score = 0
var max_stamina := 7.0
var stamina := 7.0
var exhausted := false


var walk_sound: AudioStream = preload("res://assets/sounds/Hair/Hair Walk.mp3")
var run_sound: AudioStream = preload("res://assets/sounds/Hair/Hair Run.mp3")
var dig_sound: AudioStream = preload("res://assets/sounds/Hair/Dig.mp3")
var thump_sound: AudioStream = preload("res://assets/sounds/Hair/Thump.mp3")
var thump_success_sound: AudioStream = preload("res://assets/sounds/Hair/Thump if founds.mp3")

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("dig") and global_position.distance_to(Vector2.ZERO) < 16:
		returned.emit()

	var stam_ratio = stamina / max_stamina
	if stam_ratio == 1:
		exhausted = false
		$ProgressBar.frame = 4
		$ProgressBar.hide()
	elif stam_ratio >= .75:
		$ProgressBar.show()
		$ProgressBar.frame = 3
	elif stam_ratio >= .5:
		$ProgressBar.frame = 2
	elif stam_ratio >= .25:
		$ProgressBar.frame = 1
	else:
		exhausted = true
		$ProgressBar.frame = 0

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
