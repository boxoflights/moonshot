extends KinematicBody2D

var speed = 128
var direction = Vector2.DOWN
var lifetime = 8

func _physics_process(delta):
	move_and_slide(direction * speed, Vector2.UP)
	
	if lifetime > 0:
		lifetime -= delta
		$CPUParticles2D.gravity.y += 5 * delta
	else:
		queue_free()
