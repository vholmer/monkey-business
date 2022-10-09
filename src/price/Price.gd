extends Node2D

var player_price

# Every iteration, increase the price by this much
var PRICE_INCREASE_MULTIPLIER = 1
var current_price_multiplier = 1

func _ready():
	$RichTextLabel.add_color_override("default_color", $"/root/Main".FONT_COLOR)

func _process(delta):
	var cur_price = $"../Graph".cur_price
	var price = 5 * int(cur_price)
	player_price = price
	var text_price = str(player_price).replace('.', ',')
	$RichTextLabel.bbcode_text = "[indent]" + "BNAN Stock Price: $" + text_price + "[/indent]"

func _increase_price_multiplier():
	current_price_multiplier *= PRICE_INCREASE_MULTIPLIER
	$"../Graph".cur_price *= current_price_multiplier
