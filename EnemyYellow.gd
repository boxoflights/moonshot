extends "res://Enemy.gd"

export (PackedScene) var Beam

var charging = false
var firing = false
var beam = null

func sees_player(delta, player_direction):
	speed = 0
	direction = player_direction.normalized()	
	
	if firing:
		anim = "beam"	
		
		if beam == null:
			beam = Beam.instance()
			add_child(beam)		
			
		beam.direction = direction
		if direction.x > 0:
			beam.position = $beam_right.position
		else:
			beam.position = $beam_left.position
		
	elif !charging:
		charging = true
		anim = "beam_start"
		

func idle(delta):
	if beam && beam.firing:
		firing = false
		beam.firing = false
		beam = null
	
	charging = false
	.idle(delta)

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation.begins_with("beam_start"):
		firing = true
