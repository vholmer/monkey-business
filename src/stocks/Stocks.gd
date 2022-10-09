extends Node2D

var num_owned

func _ready():
	num_owned = 0
	$RichTextLabel.add_color_override("default_color", $"/root/Main".FONT_COLOR)

func _process(delta):
	$RichTextLabel.bbcode_text = "[center]" + str(num_owned) + " Stocks" + "[/center]"
