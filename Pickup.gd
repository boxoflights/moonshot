extends Area2D

func _ready():
	pass # Replace with function body.

func _on_Pickup_body_entered(body):
	if body.is_in_group("player"):
		if(!body.has_item):
			print("PICKUP")
			body.has_item = true
			queue_free()
