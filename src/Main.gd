extends Node

var gameover
var victory

var FONT_COLOR = Color("ffdc69")

func _ready():
	$IntroMusic.set_volume_db(-15)
	$Kaching.set_volume_db(-15)
	start_game()

func start_game():
	var title = load("res://src/title/Title.tscn").instance()
	add_child(title)

	yield(title, "title_done")
	title.queue_free()

	var mainmenu = load("res://src/mainmenu/MainMenu.tscn").instance()
	add_child(mainmenu)
	$IntroMusic.play()
	
func quick_start():
	$IntroMusic.stop()
	var exchange = load("res://src/exchange/Exchange.tscn").instance()
	add_child(exchange)

func victory():
	$Exchange.queue_free()
	$Music.stop()
	victory = load("res://src/victory/Victory.tscn").instance()
	add_child(victory)

func _play_bongo():
	$Press.play()

func _start_intro():
	$MainMenu.queue_free()
	var intro = load("res://src/intro/Intro.tscn").instance()
	add_child(intro)
	
func _intro_to_exchange():
	$Intro.queue_free()
	quick_start()

func game_over():
	$Exchange.queue_free()
	$Music.stop()
	gameover = load("res://src/gameover/GameOver.tscn").instance()
	add_child(gameover)

func _retry_game():
	if gameover:
		gameover.queue_free()
	if victory:
		victory.queue_free()
	quick_start()
