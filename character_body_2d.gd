extends CharacterBody2D

const SPEED = 100.0  # Movement speed

func _physics_process(delta):
	# Start with no movement
	var velocity = Vector2.ZERO

	if Input.is_action_pressed("ui_right"):
		velocity.x += SPEED
		$AnimatedSprite2D.play("right")
	elif Input.is_action_pressed("ui_left"):
		velocity.x -= SPEED
		$AnimatedSprite2D.play("left")
	
	if velocity.x == 0:  
		if Input.is_action_pressed("ui_down"):
			velocity.y += SPEED
			$AnimatedSprite2D.play("down")
		elif Input.is_action_pressed("ui_up"):
			velocity.y -= SPEED
			$AnimatedSprite2D.play("up")

	if velocity.is_zero_approx():
		$AnimatedSprite2D.play("idle")

	if velocity.length() > 0:
		velocity = velocity.normalized() * SPEED

	self.velocity = velocity

	move_and_slide()

	var screen_size = get_viewport_rect().size
	position.x = clamp(position.x, 6, screen_size.x-6)
	position.y = clamp(position.y, 6, screen_size.y-8)
