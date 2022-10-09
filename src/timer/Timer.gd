extends Node2D

var timer

var num_dict = {
	10: "10",
	9: "9",
	8: "8",
	7: "7",
	6: "6",
	5: "5",
	4: "4",
	3: "3",
	2: "2",
	1: "1",
	0: "0"
}

func _ready():
	$RichTextLabel.add_color_override("default_color", $"/root/Main".FONT_COLOR)
	timer = Timer.new()
	timer.wait_time = 10
	timer.one_shot = true
	add_child(timer)
	timer.start()
	timer.connect("timeout", $"/root/Main/Exchange", "_ten_timeout")
	timer.connect("timeout", $"/root/Main/Exchange/Price", "_increase_price_multiplier")
	timer.connect("timeout", $"/root/Main/Exchange/Graph", "_increase_inflation")
	
func restart_timer():
	timer.wait_time = 10
	timer.one_shot = true
	timer.start()
	
func _process(delta):
	var text_num = str("%.2f" % timer.time_left).replace('.', ',')
	$RichTextLabel.bbcode_text = "[indent]" + text_num + "[/indent]"
