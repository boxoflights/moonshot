extends Area2D

var visited = false
var current_layer = 1

onready var l2 = $Layer_2
onready var l3 = $Layer_3

func _ready():
	remove_child(l2)
	remove_child(l3)

func spawn():
	if visited:
		print("SPAWN")
		if current_layer == 1:
			add_child(l2)
		elif current_layer == 2:
			add_child(l3)
			
		current_layer += 1

func _on_Screen_body_entered(body):
	if body.is_in_group("player"):
		visited = true
		print("VISITED")
