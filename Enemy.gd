extends KinematicBody2D

export (int) var move_speed = 16
export (int) var swoop_speed = 24
export (int) var view_dist = 64
export (int) var field_of_view = 180
export (int) var bite_damage = 10

var direction = Vector2.ZERO
var speed = move_speed
var anim = "idle"
var idle_timer = 2
var biting = false
var bitten = true

var bite_sound = load("res://SFX/eye-bite.wav")
var death_sound = load("res://SFX/enemy-explode.wav")
var should_play_bite_sound = false

var dead = false

func die():
	if($Body):
		remove_child($Body)
	dead = true
	var dir = "left"
	if direction.x > 0:
		dir = "right" 
	anim = "death_" + dir
	$AnimatedSprite.play(anim)
	SoundManager.play_sfx(death_sound)


func can_see_player():
	var p = get_tree().get_current_scene().get_node("Player")
	if p:
		var player_direction = p.get_node("EnemyTargetPoint").global_position - position
		if player_direction.length() < view_dist:
			var angle = acos(player_direction.normalized().dot(direction))
			if  rad2deg(angle) < field_of_view:
				$RayCast2D.cast_to = player_direction
				if $RayCast2D.is_colliding():
					if $RayCast2D.get_collider() == p:
						return player_direction
	return null

func damage_player(damage_direction, damage_amount, knockback_amount, knockback_time):
	var p = get_tree().get_current_scene().get_node("Player")
	if p:
		p.take_damage(damage_amount)
		p.knock_back(damage_direction, knockback_amount, knockback_time)

func sees_player(delta, player_direction):
	if !biting:
		anim = "idle"
	direction = player_direction.normalized()
	speed = swoop_speed

func bite_player(delta):
	biting = true
	should_play_bite_sound = true
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
	if(dead):
		return
	animate()
	
	if(
		anim == "bite" &&
		should_play_bite_sound &&
		$AnimatedSprite.frame == 8
	):
		SoundManager.play_sfx(bite_sound)
		should_play_bite_sound = false
	
	move_and_slide(direction * speed, Vector2(0, -1))
	var can_bite = false
	
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.is_in_group("player"):
			can_bite = true
	
	speed = move_speed
	
	if idle_timer > 0:
		idle_timer -= delta
	
	var player_direction = can_see_player()
	
	
	if !biting && can_bite:
		if bitten && player_direction:
			damage_player(player_direction.normalized(), bite_damage, 64, 0.5)
		bite_player(delta)
	elif player_direction != null:
		sees_player(delta, player_direction)
	elif !biting:
		idle(delta)
		
	bitten = false

func _ready():
	$RayCast2D.add_exception($Body)


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation.begins_with("bite"):
		bitten = true
		biting = false
	if $AnimatedSprite.animation.begins_with("death"):
		queue_free()
