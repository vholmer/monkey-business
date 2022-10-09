extends Node2D

var quota

var num_existing_wrenches
var cur_wrench_spawn_cap
var random
var iterations

var SPAWN_MARGIN = 100
var WRENCH_SPAWN_CAP = 3

func _ready():
	var music = load("res://music/ape-out3.ogg")
	
	random = RandomNumberGenerator.new()
	num_existing_wrenches = 0
	cur_wrench_spawn_cap = 1
	iterations = 0
	quota = 110
	
	var main_music = $"/root/Main/Music"
	
	if main_music.stream != music or not main_music.playing:
		main_music.stream = music
		main_music.set_volume_db(-15)
		main_music.play()

func _ten_timeout():
	iterations += 1
	
	for i in range(cur_wrench_spawn_cap):
		spawn_wrench()
		
	# Spawn moneybags with a 30% chance
	if randf() <= 0.3:
		spawn_moneybag()
	
	$Timer.restart_timer()
	
func spawn_wrench():
	var wrench = load("res://src/wrench/Wrench.tscn").instance()
	
	var sides = ["LEFT", "RIGHT"] # ["LEFT", "UP", "RIGHT", "DOWN"]
	randomize()
	var spawn_side = random.randi_range(0, 1) # random.randi_range(0, 3)
	
	var spawn_x
	var spawn_y
	
	var screen_size = get_viewport_rect().size
	
	if sides[spawn_side] == "LEFT":
		spawn_x = -SPAWN_MARGIN
		spawn_y = randf() * screen_size.y
	elif sides[spawn_side] == "RIGHT":
		spawn_x = screen_size.x + SPAWN_MARGIN
		spawn_y = randf() * screen_size.y
	elif sides[spawn_side] == "UP":
		spawn_x = randf() * screen_size.x
		spawn_y = -SPAWN_MARGIN
		
	wrench.position.x = spawn_x
	wrench.position.y = clamp(spawn_y, 125, 338)
	
	add_child(wrench)
	
	num_existing_wrenches += 1
	
	if cur_wrench_spawn_cap == 1 and cur_wrench_spawn_cap < WRENCH_SPAWN_CAP:
		cur_wrench_spawn_cap += 1
	if iterations == 50 and cur_wrench_spawn_cap < WRENCH_SPAWN_CAP:
		cur_wrench_spawn_cap += 1

func spawn_moneybag():
	var moneybag = load("res://src/moneybag/MoneyBag.tscn").instance()
	
	var screen_size = get_viewport_rect().size
	
	var spawn_x = randf() * screen_size.x
	var spawn_y = -SPAWN_MARGIN
	
	moneybag.position.x = spawn_x
	moneybag.position.y = spawn_y
	
	add_child(moneybag)
