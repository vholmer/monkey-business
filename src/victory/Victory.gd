extends Node2D

signal retry_game

func _ready():
	$Tada.play()
	self.connect("retry_game", $"..", "_retry_game")
	
func _process(delta):
	if not $Gorilla.is_playing():
		$Gorilla.play()
	
	if Input.is_action_just_pressed("jump"):
		emit_signal("retry_game")
