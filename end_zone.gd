extends Area2D

signal game_over

func _on_EndZone_body_entered(body):
	if body.is_in_group("timer"):  
		emit_signal("game_over") 
