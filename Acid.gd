extends KinematicBody2D

var speed = 128
var direction = Vector2.DOWN
var lifetime = 10
var landed = false

func _physics_process(delta):
	move_and_slide(direction * speed, Vector2.UP)
	
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.is_in_group("tiles"):
			if !landed:
				$CPUParticles2D.visible = false
				$AnimatedSprite.visible = true
				$AnimatedSprite.animation = 'splash'
				landed = true
	
	if lifetime > 0:
		lifetime -= delta
	else:
		queue_free()


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == 'splash':
		$AnimatedSprite.animation = 'default'
