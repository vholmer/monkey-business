extends Node2D

signal menu_to_intro

var blink_visible = true

func _ready():
	self.connect("menu_to_intro", $"/root/Main", "_start_intro")
	self.connect("menu_to_intro", $"/root/Main", "_play_bongo")
	blink_visible = true
	$BlinkTimer.wait_time = 0.6
	$BlinkTimer.connect("timeout", self, "_toggle_blink")
	$BlinkTimer.start()
	
func _toggle_blink():
	if blink_visible:
		$PressSpace.modulate.a = 1
		blink_visible = false
	else:
		$PressSpace.modulate.a = 0
		blink_visible = true
	$BlinkTimer.start()

func _process(delta):
	if Input.is_action_just_pressed("jump"):
		emit_signal("menu_to_intro")
