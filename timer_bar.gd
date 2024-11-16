extends CharacterBody2D

var timer_speed = -10.0  

func _physics_process(delta):
	velocity.x = timer_speed  
	move_and_slide()  
