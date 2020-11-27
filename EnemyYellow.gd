extends "res://Enemy.gd"

export (PackedScene) var Beam
export (int) var beam_damage = 50

var charging = false
var firing = false
var beam = null

func sees_player(delta, player_direction):
	speed = 8
	direction = player_direction.normalized()	
	if player_direction.length() > 32:
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
	elif !charging:
		clear_beam(delta)
		.sees_player(delta, player_direction)

func clear_beam(delta):
	if beam && beam.firing:
		firing = false
		beam.firing = false
		beam = null

func bite_player(delta):
	if !charging:
		clear_beam(delta)
		.bite_player(delta)

func idle(delta):
	if !charging:
		clear_beam(delta)
		.idle(delta)

func _physics_process(delta):
	if beam && beam.hit != null:
		if beam.hit.is_in_group("player"):
			damage_player(beam.direction, beam_damage * delta, 16, 0.5)

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation.begins_with("beam_start"):
		charging = false
		firing = true
