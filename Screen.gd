extends Area2D

var visited = false
var current_layer = 1

onready var l2 = $Layer_2
onready var l3 = $Layer_3
onready var l4 = $Layer_4
onready var l5 = $Layer_5
onready var l6 = $Layer_6

func _ready():
	remove_child(l2)
	remove_child(l3)
	remove_child(l4)
	remove_child(l5)
	remove_child(l6)

func spawn():
	if visited:
		print("SPAWN")
		if current_layer == 1:
			add_child(l2)
		elif current_layer == 2:
			add_child(l3)
		elif current_layer == 3:
			add_child(l4)
		elif current_layer == 4:
			add_child(l5)
		elif current_layer == 5:
			add_child(l6)
		
		visited = false
		current_layer += 1

func _on_Screen_body_entered(body):
	if body.is_in_group("player"):
		visited = true		
		print("VISITED")
		var cp = get_node("Checkpoint")
		if cp:
			body.last_checkpoint = cp.global_position
			print("CHECKPOINT")
