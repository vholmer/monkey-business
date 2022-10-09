extends Node2D

signal retry_game

func _ready():
	$GameOver.set_volume_db(-15)
	$GameOver.play()
	self.connect("retry_game", $"..", "_retry_game")

func _process(delta):
	if Input.is_action_just_pressed("jump"):
		emit_signal("retry_game")
