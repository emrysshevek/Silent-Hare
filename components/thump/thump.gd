extends Area2D
var closest : Area2D

var arrow : Sprite2D
var duration : Timer
var cooldown : Timer
var particles : CPUParticles2D

var duration_state = false
var cooldown_state = false

var foods = []

func _ready():
	arrow = get_node("Sprite2D")
	duration = get_node("Duration")
	cooldown = get_node("CoolDown")
	particles = get_node("CPUParticles2D")

func _physics_process(delta):
	var foods_close = get_overlapping_areas()
	foods.clear()
	
	if foods_close.size() > 0: # all this is making sure that it is pointing at the closest area with parent of Food class
		for i in range(foods_close.size()):
			var check = foods_close[i]
			if check.get_parent() is Food:
				foods.append(check)
		if foods.size()> 0:
			closest = foods[0]
			for j in range(foods.size()):
				var distance = global_position.distance_to(foods[j].global_position)
				if distance < global_position.distance_to(closest.global_position):
					closest = foods[j]
		else:
			closest = null
	else:
		closest = null


	if duration.time_left == 0: # timer conditioning
		duration_state = false
	if cooldown.time_left == 0:
		cooldown_state = true
	
	# if Input.is_action_just_pressed("thump") and cooldown_state == true: #more timer conditioning
	# 	cooldown.start()
	# 	thump()
	# 	cooldown_state = false

		

func _on_duration_timeout():
	duration_state = false
	
func _on_cool_down_timeout():
	cooldown_state = true


func thump():
	print("thumping")
	if closest and closest.is_inside_tree():
		particles.direction = global_position.direction_to(closest.global_position)
		var distance = clamp(1 - global_position.distance_to(closest.global_position) / 64, 0, 1)
		print(distance)
		particles.spread = (distance ** 2) * 180	 
		particles.initial_velocity_min = 50
		particles.initial_velocity_max = 80
		particles.emitting = true
