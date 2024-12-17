extends Area2D
var closest
var arrow : Sprite2D
var duration : Timer
var delay : Timer

func _ready():
	arrow = get_node("Sprite2D")
	duration = get_node("Duration")
	delay = get_node("delay")
	
func _physics_process(delta):
	var foods_colse = get_overlapping_areas()
	if foods_colse.size() > 0:
		closest = foods_colse.front()
	
	if delay.time_left == 0 and Input.is_action_just_pressed("thump"):
		print("iohq")
		duration.start()
	if duration.time_left >0:
		thump()
		delay.start()
	else:
		arrow.visible = false
	

func thump():
	arrow.look_at(closest.global_position)
	arrow.visible = true
