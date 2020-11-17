extends Area2D

export (int) var max_beam_length = 128
export (int) var beam_speed = 128

var firing = true;
var beam_length = 0
var direction = Vector2.ZERO

func _physics_process(delta):	
	if firing:
		if beam_length < max_beam_length:
			beam_length += beam_speed * delta
	else:
		queue_free()
	
	var vec = direction * beam_length
	
	$Line2D.points[1] = vec
	
	$RayCast2D.cast_to = $Line2D.points[1]
	if $RayCast2D.is_colliding():
		var collider = $RayCast2D.get_collider()
		var target =  $RayCast2D.get_collision_point() - get_parent().position
		$Line2D.points[1] = target
		$CPUParticles2D.position = target
		$CPUParticles2D.direction = -direction
		$CPUParticles2D.emitting = true
	else:
		$CPUParticles2D.emitting = false
	
