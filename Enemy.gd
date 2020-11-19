extends KinematicBody2D

export (int) var move_speed = 16
export (int) var swoop_speed = 24
export (int) var view_dist = 64
export (int) var field_of_view = 180

var direction = Vector2.ZERO
var speed = move_speed
var anim = "idle"
var idle_timer = 2
var biting = false;

func can_see_player():
	var p = get_parent().get_node("Player")
	if p:
		var player_direction = p.position - position
		if player_direction.length() < view_dist:
			var angle = acos(player_direction.normalized().dot(direction))
			if  rad2deg(angle) < field_of_view:
				$RayCast2D.cast_to = player_direction
				if $RayCast2D.is_colliding():
					if $RayCast2D.get_collider() == p:
						return player_direction
	return null

func sees_player(delta, player_direction):
	if !biting:
		anim = "idle"
	direction = player_direction.normalized()
	speed = swoop_speed

func bite_player(delta):
	biting = true
	anim = "bite"

func idle(delta):
	anim = "idle"
	
	if idle_timer <= 0:
		if direction.x > 0:
			direction = Vector2.LEFT
		else:
			direction = Vector2.RIGHT
		
		idle_timer = 2

func animate():
	var dir = "left"
	if direction.x > 0:
		dir = "right" 
	$AnimatedSprite.animation = anim + "_" + dir

func _physics_process(delta):
	animate()
	
	move_and_slide(direction * speed, Vector2(0, -1))
	var can_bite = false
	
	if !biting:	
		for i in get_slide_count():
			var collision = get_slide_collision(i)
			if collision.collider.is_in_group("player"):
				can_bite = true
	
	speed = move_speed
	
	if idle_timer > 0:
		idle_timer -= delta
	
	var player_direction = can_see_player()
	
	if player_direction != null:
		if can_bite:
			bite_player(delta)
		else:
			sees_player(delta, player_direction)
	else:
		idle(delta)

func _ready():
	$RayCast2D.add_exception($Body)


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation.begins_with("bite"):
		biting = false
	pass # Replace with function body.
