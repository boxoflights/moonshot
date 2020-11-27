extends Area2D

func _on_Pickup_body_entered(body):
	if body.is_in_group("player"):
		if(!body.has_item):
			print("PICKUP")
			body.has_item = true
			owner.respawn()
			queue_free()
