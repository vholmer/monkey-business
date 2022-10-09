extends Node2D

var money
var quota

func _ready():
	money = 100
	quota = 1000
	$RichTextLabel.add_color_override("default_color", $"/root/Main".FONT_COLOR)
	
func increase_quota():
	quota = int(1.33 * quota)

func _process(delta):
	$RichTextLabel.bbcode_text = "[center]" + "$" + str(money) + " / " + "$" + str(quota) + "[/center]"
	
	if money >= quota:
		$"/root/Main".victory()
