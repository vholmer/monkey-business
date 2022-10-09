extends Node2D

signal title_done

var extra_cheese_timer
var darkness_timer
var time_one_way

func _ready():
	time_one_way = 2.5
	
	$Splash.modulate.a = 0
	
	$ExtraCheese.stream = load("res://sfx/extra_cheese.wav")
	
	extra_cheese_timer = Timer.new()
	extra_cheese_timer.one_shot = true
	extra_cheese_timer.wait_time = time_one_way
	extra_cheese_timer.connect("timeout", self, "_on_ExtraCheese_timeout")
	add_child(extra_cheese_timer)
	
	darkness_timer = Timer.new()
	darkness_timer.one_shot = true
	darkness_timer.wait_time = time_one_way / 3
	darkness_timer.connect("timeout", self, "_on_Darkness_timeout")
	add_child(darkness_timer)
	
	$ExtraCheese.connect("finished", self, "_on_ExtraCheesed")
	
	darkness_timer.start()

func _on_Darkness_timeout():
	$Tween.interpolate_property($Splash, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), time_one_way, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	
	extra_cheese_timer.start()

func _on_ExtraCheese_timeout():
	$ExtraCheese.play()

func _on_ExtraCheesed():
	$Tween.interpolate_property($Splash, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), time_one_way, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	yield($Tween, "tween_completed")
	emit_signal("title_done")
