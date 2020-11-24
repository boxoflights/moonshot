extends "res://Enemy.gd"

export (PackedScene) var Acid

export (int) var drop_time = 4

var drop_timer = drop_time

var flank = false

func sees_player(delta, player_direction):
	var angle = acos(player_direction.normalized().dot(Vector2.DOWN))
	if rad2deg(angle) < 15:
		drop()
		
	if player_direction.length() < 32:
		.sees_player(delta, player_direction)
	else:
		var orig_pos = player_direction + position
		var x = 64
		if player_direction.x > 0 && player_direction.x < 64:
			flank = false
		elif player_direction.x < 0:
			flank = true
			
		if flank: x = -x
		
		orig_pos += Vector2(x, -64)
		orig_pos -= position
		.sees_player(delta, orig_pos)

func drop():
	if drop_timer <= 0:
		var acid = Acid.instance()
		owner.add_child(acid)
		acid.transform = global_transform
		drop_timer = drop_time

func _physics_process(delta):
	if drop_timer > 0:
		drop_timer -= delta
