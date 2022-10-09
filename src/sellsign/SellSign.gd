extends Node2D

func _ready():
	$Timer.wait_time = 0.5
	$Timer.connect("timeout", self, "_disable_dollar")

func blink():
	$Sell.visible = false
	$Dollar.visible = true
	$Timer.start()

func _disable_dollar():
	$Sell.visible = true
	$Dollar.visible = false
