extends KinematicBody2D

var direction

var speed
var has_been_in_view

func _ready():
	has_been_in_view = false
	randomize()
	$Sprite.rotation = randf() * PI
	$Timer.wait_time = randf() * 2
	$Timer.connect("timeout", self, "_set_direction")
	$Timer.start()
	
func _set_direction():
	direction = rand_range(0.2, 1.8) * $"/root/Main/Exchange/Player".position - position

func _physics_process(delta):
	$Sprite.rotation += 10 * delta
	
	if $Timer.time_left == 0:
		position += direction * delta * 0.3

	var screen_size = get_viewport_rect().size
	
	var on_screen = position.x > -50 and position.x < screen_size.x + 50 and position.y > -50 and position.y < screen_size.y + 50

	if on_screen:
		has_been_in_view = true
		
	if not on_screen and has_been_in_view:
		self.queue_free()
