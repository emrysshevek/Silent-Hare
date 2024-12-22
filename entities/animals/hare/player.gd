
class_name Player extends Animal

@onready var audio: AudioStreamPlayer2D = get_node("AudioStreamPlayer2D")
@onready var sprite: AnimatedSprite2D = get_node("AnimatedSprite2D")

var food = null
var what_area = 2 
var score = 0


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
