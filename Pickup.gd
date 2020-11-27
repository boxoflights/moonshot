extends Area2D

var sfx = load("res://SFX/pickup-noise.wav")

func _on_Pickup_body_entered(body):
	if body.is_in_group("player"):
		if(!body.has_item):
			print("PICKUP")
			body.has_item = true
			owner.respawn()
			SoundManager.play_sfx(sfx)
			queue_free()
