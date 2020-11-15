extends KinematicBody2D


export (int) var move_speed = 24
export (int) var swoop_speed = 36
export (int) var max_dist = 64
export (int) var field_of_view = 180

var direction = Vector2.LEFT
var swooping = false
var biting = false

func _physics_process(delta):
	var speed = move_speed
	var p = get_parent().get_node("Player")
	if p:
		var dist = p.position - position
		if dist.length() < max_dist:
			if acos(dist.normalized().dot(direction)) < field_of_view:
				$RayCast2D.cast_to = dist
				if $RayCast2D.is_colliding():
					if $RayCast2D.get_collider() == p:
						direction = dist.normalized()
						swooping = true
						speed = swoop_speed
						
	move_and_slide(direction * speed, Vector2(0, -1))
	
	biting = false	
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider == p:
			biting = true
			
	if biting:
		$AnimatedSprite.animation = "bite_left"
		
	
	
func _ready():
	$RayCast2D.add_exception($Body)
