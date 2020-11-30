extends "res://Enemy.gd"

export (PackedScene) var Acid

export (int) var drop_time = 4

var drop_timer = drop_time

var flank = 0
var flank_dir = -1

func sees_player(delta, player_direction):
	var angle = acos(player_direction.normalized().dot(Vector2.DOWN))
	if rad2deg(angle) < 15:
		drop()
		
	if player_direction.length() < 32:
		.sees_player(delta, player_direction)
	else:
		var orig_pos = player_direction + position
		
		if flank <= -16:
			flank_dir = 1
		elif flank >= 16:
			flank_dir = -1
		
		flank += flank_dir
			
		orig_pos += Vector2(flank, -32)
		orig_pos -= position
		.sees_player(delta, orig_pos)

func drop():
	if drop_timer <= 0:
		var acid = Acid.instance()
		get_tree().get_current_scene().add_child(acid)
		acid.transform = global_transform
		drop_timer = drop_time

func _physics_process(delta):
	if(dead):
		return
	if drop_timer > 0:
		drop_timer -= delta
