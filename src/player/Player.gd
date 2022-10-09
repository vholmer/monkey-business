extends KinematicBody2D

var collision
var gravity
var speed
var velocity
var floor_y
var screen_size
var invincible
var hitpoints
var blink_visible
var stock_prices

func _ready():
	stock_prices = []
	blink_visible = true
	invincible = false
	hitpoints = 4
	speed = 400
	gravity = 35
	floor_y = 300
	velocity = Vector2.ZERO
	screen_size = get_viewport_rect().size
	$Damage.set_volume_db(-5)
	$Jump.set_volume_db(-17)
	$AnimatedSprite.play("idle")
	$BlinkTimer.connect("timeout", self, "_toggle_blink")
	$InvincibilityTimer.connect("timeout", self, "_disable_invincibility")

func _toggle_blink():
	if blink_visible:
		$AnimatedSprite.modulate.a = 0
		if hitpoints >= 2:
			$Banana1.modulate.a = 0
		if hitpoints >= 3:
			$Banana2.modulate.a = 0
		if hitpoints >= 4:
			$Banana3.modulate.a = 0
		
		blink_visible = false
	else:
		$AnimatedSprite.modulate.a = 1
		if hitpoints >= 2:
			$Banana1.modulate.a = 1
		if hitpoints >= 3:
			$Banana2.modulate.a = 1
		if hitpoints >= 4:
			$Banana3.modulate.a = 1
		blink_visible = true
	$BlinkTimer.start()
		
func _disable_invincibility():
	invincible = false
	blink_visible = true
	$BlinkTimer.stop()
	$BlinkTimer.wait_time = 0.1
	$AnimatedSprite.modulate.a = 1
	if hitpoints >= 2:
		$Banana1.modulate.a = 1
	if hitpoints >= 3:
		$Banana2.modulate.a = 1
	if hitpoints >= 4:
		$Banana3.modulate.a = 1

func _physics_process(delta):
	velocity.x = 0
	
	var jump = false
	var money = $"../Quota".money
	var stocks_owned = $"../Stocks".num_owned
	var player_price = $"../Price".player_price
	
	if Input.is_action_pressed("move_left"):
		velocity.x -= speed
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_h = true
	if Input.is_action_pressed("move_right"):
		velocity.x += speed
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_h = false
	if not Input.is_action_pressed("move_right") and not Input.is_action_pressed("move_left"):
		$AnimatedSprite.animation = "idle"
	if Input.is_action_just_pressed("jump") and velocity.y == 0:
		$Jump.play()
		velocity.y -= 2 * speed
		jump = true
	if Input.is_action_just_pressed("buy") and money > 0 and (money - player_price) >= 0:
		if not $"/root/Main/Kaching".playing:
			$"/root/Main/Kaching".play()
		stock_prices.append(player_price)
		$"../Quota".money -= player_price
		$"../Stocks".num_owned += 1
		$"../BuySign".blink()
	if Input.is_action_just_pressed("sell") and stocks_owned > 0:
		if not $"/root/Main/Klirr".playing:
			$"/root/Main/Klirr".play()
		$"../Quota".money += player_price
		$"../Stocks".num_owned -= 1
		$"../SellSign".blink()
	#if Input.is_action_pressed("quit"):
	#	get_tree().quit()
		
	if position.y < floor_y:
		velocity.y += gravity
	elif not jump:
		velocity.y = 0
		
	position += velocity * delta
	
	position.x = clamp(position.x, 51, screen_size.x - 51)
	position.y = clamp(position.y, 0, floor_y)
	
	var collision = move_and_collide(velocity * delta, true, true, true)
	
	if collision:
		var collider_name = collision.collider.name
		
		var wrench_collision = "Wrench" in collider_name
		var money_collision = "MoneyBag" in collider_name
		
		if wrench_collision and not invincible:
			$Damage.play()
			collision.collider.queue_free()
			hitpoints -= 1
			$BlinkTimer.start()
			$InvincibilityTimer.start()
			invincible = true
			if hitpoints == 3:
				$Banana3.queue_free()
			elif hitpoints == 2:
				$Banana2.queue_free()
			elif hitpoints == 1:
				$Banana1.queue_free()
			elif hitpoints == 0:
				$"/root/Main".game_over()
				
		if money_collision:
			var sum = 0
			var i = 0
			for price in stock_prices:
				sum += price
				i += 1
			var avg_bought_price = 0
			if i > 0:
				avg_bought_price = sum / i
			
			var player_money = $"../Quota".money
			var player_stocks = $"../Stocks".num_owned
			var net_worth = player_money + avg_bought_price * player_stocks
			
			$"/root/Main/Kaching".play()
			# Every money bag is worth 20 + 10% of player's net_worth
			$"../Quota".money += int(20 + 0.1 * net_worth)
			collision.collider.queue_free()
