extends Area2D

func fire(direction, distance):
	var vec = direction * distance
	$Line2D.points[1].x = vec.x
	$Line2D.points[1].y = vec.y
	
	$RayCast2D.cast_to = vec
	if $RayCast2D.is_colliding():
		var collider = $RayCast2D.get_collider()
		var target =  $RayCast2D.get_collision_point() - position
		$Line2D.points[1].x = target.x
		$Line2D.points[1].y = target.y

func retract(direction, distance):
	var vec = direction * distance
	$Line2D.points[0].x = vec.x
	$Line2D.points[0].y = vec.y
