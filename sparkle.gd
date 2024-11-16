extends Area2D

signal sparklecollect

func _on_body_entered(body):
	if body.is_in_group("player"):  
		emit_signal("sparklecollect")
