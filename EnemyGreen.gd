extends "res://Enemy.gd"

export (PackedScene) var Acid

export (int) var drop_time = 4

var drop_timer = drop_time

func sees_player(delta, player_direction):
	var angle = acos(player_direction.normalized().dot(Vector2.DOWN))
	if rad2deg(angle) < 15:
		drop()
	.sees_player(delta, player_direction)

func drop():
	if drop_timer <= 0:
		var acid = Acid.instance()
		owner.add_child(acid)
		acid.transform = global_transform
		drop_timer = drop_time

func idle(delta):
	#drop()
	
	#.idle(delta)
	pass

func _physics_process(delta):
	if drop_timer > 0:
		drop_timer -= delta
