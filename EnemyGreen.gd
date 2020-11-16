extends "res://Enemy.gd"

export (int) var drop_time = 2
var drop_timer = drop_time

func drop(delta):
	pass

func idle(delta):
	if drop_timer > 0:
		drop_timer -= delta
	else:
		drop(delta)
	
	.idle(delta)
