extends Area2D

export (int) var direction = 1
var speed = 160

func _physics_process(delta):
	position.x += direction * speed * delta

func _on_Lazer_body_entered(body):
	if body.is_in_group("mobs"):
		body.queue_free()
	queue_free()
	
