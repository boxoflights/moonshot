extends "res://Enemy.gd"

export (PackedScene) var Beam

var beam = null
var beam_length = 0

func sees_player(delta, player_direction):
	speed = 0
	direction = player_direction.normalized()
	anim = "beam"
	if beam_length < 128:
		beam_length+=128 * delta
	
	if beam == null:
		beam = Beam.instance()
		owner.add_child(beam)
		beam.transform = global_transform
	
	beam.fire(direction, beam_length)

func idle(delta):
	if beam_length > 0:
		beam_length-=128 * delta
		beam.retract(direction, 128 - beam_length)
	elif beam != null:
		beam.queue_free()
		beam = null
	else:
		.idle(delta)

func _on_AnimatedSprite_animation_finished():
	pass # Replace with function body.
