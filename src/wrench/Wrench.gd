extends KinematicBody2D

var direction

var speed
var rand_speed
var has_been_in_view

func _ready():
	has_been_in_view = false
	randomize()
	rand_speed = clamp(1 + randf(), 1, 1.5)
	$Sprite.rotation = randf() * PI
	if $"/root/Main/Exchange".num_existing_wrenches > 1:
		$Timer.wait_time = randf() * 2
	else:
		$Timer.wait_time = 0
	$Timer.connect("timeout", self, "_set_direction")
	$Timer.start()
	
func _set_direction():
	direction = $"/root/Main/Exchange/Player".position - position

func _physics_process(delta):
	$Sprite.rotation += 10 * delta
	
	if $Timer.time_left == 0:
		position += direction * delta * rand_speed * 0.3

	var screen_size = get_viewport_rect().size
	
	var on_screen = position.x > -50 and position.x < screen_size.x + 50 and position.y > -50 and position.y < screen_size.y + 50

	if on_screen:
		has_been_in_view = true
		
	if not on_screen and has_been_in_view:
		$"/root/Main/Exchange".num_existing_wrenches -= 1
		self.queue_free()
