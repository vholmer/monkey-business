extends Node2D

var pegs
var peg_timer
var peg_step_size
var cur_price
var volatility
var line
var line_up
var line_down

var min_price_visible
var max_price_visible

var inflation = 1.02

var GRAPH_HEIGHT = 94
var PEG_STEP_SIZE = 10
var VOLATILITY = 0.1
var PEG_MAX_X = 373
var PEG_MIN_X = -PEG_MAX_X

var LINE_COLOR = Color.yellow # Color("ffdc69")
var LINE_WIDTH = 5

var LINE_OUTLINE_COLOR = Color.gold
var LINE_OUTLINE_WIDTH = 1.5
var LINE_OUTLINE_OFFSET = 3

func next_price():
	var rnd = randf()
	var change_percent = 2 * VOLATILITY * rnd
	var player_money = $"../Quota".money
	var player_stocks = $"../Stocks".num_owned
	var player_bought_prices = $"../Player".stock_prices
	var avg_bought_price = cur_price
	
	if player_bought_prices:
		var sum = 0
		var i = 0
		for price in player_bought_prices:
			sum += price
			i += 1
		
		avg_bought_price = sum / i
	
	# Set these values for initial simulation
	if player_money == null:
		player_money = 100
		
	if player_stocks == null:
		player_stocks = 0
		
	var net_worth = player_money + avg_bought_price * player_stocks
	
	if change_percent > VOLATILITY:
		change_percent -= 2 * VOLATILITY
		
	var change_amount = cur_price * change_percent
	
	var lower_bound = clamp(0.5 * (net_worth / 5), 5, 999)
	var upper_bound = 2 * (net_worth / 5)

	return clamp(cur_price + change_amount, lower_bound, upper_bound)

func _physics_process(delta):
	# Move all the pegs by PEG_SET_SIZE
	var indices_to_remove = []
	
	for i in range(pegs.size()):
		var pegg = pegs[i]
		pegg.position.x -= PEG_STEP_SIZE * PEG_STEP_SIZE * delta
		if pegg.position.x < PEG_MIN_X:
			indices_to_remove.append(i)
	
	# Remove pegs outside graph
	var num_removed = 0
	
	while num_removed != indices_to_remove.size():
		var index_to_remove = indices_to_remove[0]
		index_to_remove -= num_removed
		var peg_to_remove = pegs[index_to_remove]
		pegs.remove(index_to_remove)
		peg_to_remove.queue_free()
		num_removed += 1
		
	# Draw lines between the pegs
	draw_lines()
		
func draw_lines():
	line_up.clear_points()
	line.clear_points()
	line_down.clear_points()
	for pegg in pegs:
		var up_pos = pegg.position
		up_pos.y -= LINE_OUTLINE_OFFSET
		line_up.add_point(up_pos)
		
		line.add_point(pegg.position)
		
		var down_pos = pegg.position
		down_pos.y += LINE_OUTLINE_OFFSET
		line_down.add_point(down_pos)

func _ready():
	pegs = []
	cur_price = 10
	line = Line2D.new()
	line.default_color = LINE_COLOR
	line.width = LINE_WIDTH
	line.joint_mode = line.LINE_JOINT_SHARP
	add_child(line)
	
	line_up = Line2D.new()
	line_up.default_color = LINE_OUTLINE_COLOR
	line_up.width = LINE_OUTLINE_WIDTH
	line_up.joint_mode = line_up.LINE_JOINT_SHARP
	add_child(line_up)
	
	line_down = Line2D.new()
	line_down.default_color = LINE_OUTLINE_COLOR
	line_down.width = LINE_OUTLINE_WIDTH
	line_down.joint_mode = line_down.LINE_JOINT_SHARP
	add_child(line_down)
	
	randomize()
	
	# Simulate 1000 points before start
	for i in range(100):
		_peg_timer_timeout(true)
	
	peg_timer = Timer.new()
	add_child(peg_timer)
	peg_timer.wait_time = 0.1
	peg_timer.one_shot = false
	peg_timer.connect("timeout", self, "_peg_timer_timeout")
	peg_timer.start()
	
func _peg_timer_timeout(move=false):
	# Spawn pegs every timeout on the scaled y-position of current price
	var old_price = cur_price
	cur_price = next_price()
	cur_price = clamp(cur_price, 0, 999999999)
	
	var peg = load("res://src/graph/Peg.tscn").instance()
	
	# NOTE: relative to graph
	peg.position.x = PEG_MAX_X
	peg.price = cur_price
	
	add_child(peg)
	
	pegs.append(peg)
		
	# Update max and min visible
	if pegs.size() > 2:
		var max_found = -9999999
		var min_found = 9999999
		for pegg in pegs:
			if pegg.price > max_found:
				max_found = pegg.price
			if pegg.price < min_found:
				min_found = pegg.price
		max_price_visible = max_found
		min_price_visible = min_found
	
	# Scale all pegs y-positions
	if pegs.size() > 2:
		for pegg in pegs:
			var pegg_scaled_price
			if max_price_visible - min_price_visible == 0:
				pegg_scaled_price = pegg.price
			else:
				pegg_scaled_price = (pegg.price - min_price_visible) / (max_price_visible - min_price_visible)
				pegg_scaled_price = 1 - pegg_scaled_price
			pegg.position.y = pegg_scaled_price * (GRAPH_HEIGHT - 10) - ((GRAPH_HEIGHT - 10) / 2)
			pegg.scaled_price = pegg_scaled_price
			
	# Move all the pegs by PEG_STEP_SIZE
	var indices_to_remove = []

	for i in range(pegs.size()):
		var pegg = pegs[i]
		if move:
			pegg.position.x -= PEG_STEP_SIZE
		if pegg.position.x < PEG_MIN_X:
			indices_to_remove.append(i)

	# Remove pegs outside graph
	var num_removed = 0

	while num_removed != indices_to_remove.size():
		var index_to_remove = indices_to_remove[0]
		index_to_remove -= num_removed
		var peg_to_remove = pegs[index_to_remove]
		pegs.remove(index_to_remove)
		peg_to_remove.queue_free()
		num_removed += 1

	# Draw lines between the pegs
	#draw_lines()
