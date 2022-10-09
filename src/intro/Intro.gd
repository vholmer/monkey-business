extends Node2D

signal intro_done

var intro_index
var blink_visible = true

func _ready():
	intro_index = 1
	blink_visible = true
	self.connect("intro_done", $"/root/Main", "_intro_to_exchange")
	self.connect("intro_done", $"/root/Main", "_play_bongo")
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
	if Input.is_action_just_pressed("jump") and intro_index == 1:
		$"/root/Main"._play_bongo()
		$First.visible = false
		$Second.visible = true
		intro_index += 1
	elif Input.is_action_just_pressed("jump") and intro_index == 2:
		$"/root/Main"._play_bongo()
		$Second.visible = false
		$Third.visible = true
		intro_index += 1
	elif Input.is_action_just_pressed("jump") and intro_index == 3:
		emit_signal("intro_done")
