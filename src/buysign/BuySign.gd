extends Node2D

func _ready():
	$Timer.wait_time = 0.5
	$Timer.connect("timeout", self, "_disable_dollar")

func blink():
	$Buy.visible = false
	$Dollar.visible = true
	$Timer.start()

func _disable_dollar():
	$Buy.visible = true
	$Dollar.visible = false
