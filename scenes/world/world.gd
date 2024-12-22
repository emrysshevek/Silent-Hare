class_name World extends Node2D

@export var chunk_size := 8

@onready var player := $Player
@onready var ap: AnimationPlayer = $AnimationPlayer

var chunk_data: Dictionary = {}
var active_chunks: Dictionary = {}
var prev_chunk: Vector2i = Vector2i.MAX
var day_duration: float = 300
var day_remaining: float = 300
var min_score = 15
var days_survived = 0
var game_over = false
var started = false

var save_root = "res://save_data/world/"

enum Biome {
	SNOW,
	FOREST
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	BackgroundMusicManager.crossfade_to(BackgroundMusicManager.BackgroundTrack.PEACE)
	player.died.connect(on_player_died)
	player.score_changed.connect(on_player_score_changed)
	player.returned.connect(on_player_returned)
	player.position = Vector2(100000, 100000)

	Globals.world = self
	Globals.player = player
	Globals.camera = get_node("Camera2D")

func start_day() -> void:
	for key in active_chunks.keys():
		active_chunks.erase(key)
	player.score = 0
	player.score_changed.emit()
	ap.play("intro")
	player.position = Vector2.ZERO
	player.show()
	prev_chunk = Vector2i.MAX
	started = true

func end_day() -> void:
	days_survived += 1
	day_remaining = day_duration
	ap.play("wipe")
	player.hide()
	get_tree().create_timer(1.5).timeout.connect(start_day)

func on_player_returned() -> void:
	if player.score >= min_score:
		end_day()

func on_player_score_changed() -> void:
	var text = $UILayer/Control/MarginContainer/HBoxContainer/Label
	text.text = str(player.score) + "/" + str(min_score)

func on_player_died() -> void:
	var hare: Node2D = load("res://entities/items/dead_hare.tscn").instantiate()
	add_child(hare)
	hare.global_position = player.global_position
	BackgroundMusicManager.crossfade_to(BackgroundMusicManager.BackgroundTrack.DEATH)
	var tween = create_tween()
	tween.tween_property(Globals.camera, "zoom", Vector2(1.5, 1.5), 10)
	tween.finished.connect(on_zoom_finished)
	var end = $UILayer/Control/Death/Label
	end.text = "You survived " + str(days_survived) + " day(s)"
	$UILayer/Control.show()

func on_zoom_finished() -> void:
	game_over = true

func show_menu() -> void:
	var ap: AnimationPlayer = get_node("AnimationPlayer")
	ap.play("wipe")
	ap.animation_finished.connect(quit)

func quit(name) -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("dig"):
		if game_over:
			show_menu()
		if not started:
			$UILayer/Control/Instructions.hide()
			start_day()

	day_remaining -= delta
	if day_remaining <= 0:
		if is_instance_valid(player):
			player.kill()
		return

	
	var tint: ColorRect = $UILayer/Control/NightOverlay
	tint.color = Color.from_hsv(0, 0, 0, 1 - day_remaining / day_duration)


func _process(delta: float) -> void:
	if not is_instance_valid(player):
		return

	var curr_chunk := position_to_chunk(player.global_position)
	if curr_chunk == prev_chunk:
		return

	# print("entered new chunk: ", curr_chunk)
	prev_chunk = curr_chunk
	for key in active_chunks.keys():
		if abs(active_chunks[key].coords.x - curr_chunk.x) > 1 or abs(active_chunks[key].coords.y - curr_chunk.y) > 1:
			print("unloading chunk: ", key)
			update_chunk_data(active_chunks[key])
			active_chunks[key].queue_free()
			active_chunks.erase(key)

	for i in range(curr_chunk.x - 1, curr_chunk.x + 2):
		for j in range(curr_chunk.y - 1, curr_chunk.y + 2):
			var key = Vector2i(i, j)
			if key not in active_chunks:	
				print("spawning chunk: ", key)
				var chunk = load("res://scenes/world/chunk.tscn").instantiate()
				add_child(chunk)
				if key in chunk_data:
					chunk.food_locations = chunk_data[key]["food"]
					chunk.den_location = chunk_data[key]["den"]
					chunk.hole_locations = chunk_data[key]["holes"]
					chunk.generate(key, false, false)
				else:
					chunk.generate(Vector2i(i, j))
				update_chunk_data(chunk)
				active_chunks[key] = chunk

func update_chunk_data(chunk: Chunk) -> void:
	chunk_data[chunk.coords] = {
		"food": chunk.food_locations,
		"den": chunk.den_location,
		"holes": chunk.hole_locations
	}

func load_saved_chunk(key: Vector2i) -> Chunk:
	var path = save_root + str(key.x) + "_" + str(key.y) + ".tscn"
	if ResourceLoader.exists(path):
		return load(path).instantiate()
	else:
		return null

func add_snow_hole(pos: Vector2) -> void:
	var chunk = active_chunks[position_to_chunk(player.global_position)]
	chunk.spawn_hole(pos)

func cell_to_chunk(cell: Vector2i) -> Vector2i:
	return Vector2i(cell.x / chunk_size, cell.y / chunk_size)

func position_to_chunk(pos: Vector2) -> Vector2i:
	return Vector2i(floor(pos.x / (Constants.CHUNK_SIZE * Constants.TILE_SIZE)), floor(pos.y / (Constants.CHUNK_SIZE * Constants.TILE_SIZE)))

# func _input(event: InputEvent) -> void:
# 	if event is InputEventMouseButton:
# 		if event.is_pressed():
# 			# zoom in
# 			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
# 				get_node("Camera2D").zoom *= 1.1				
# 			# zoom out
# 			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
# 				get_node("Camera2D").zoom /= 1.1
