extends Node2D

enum views {
	MAINMENU,
	OPTIONS
}

var current_view = views.MAINMENU

# Called when the node enters the scene tree for the first time.
func _ready():
	set_view(views.MAINMENU)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_view(new_view):
	match new_view:
		views.MAINMENU:
			$Camera.position = Vector2(0,0)
			current_view = new_view
		views.OPTIONS:
			$Camera.position = Vector2(360,0)
			current_view = new_view

func _on_OPTIONS_pressed():
	set_view(views.OPTIONS)

func _on_OptionsBack_pressed():
	set_view(views.MAINMENU)

func _on_PLAY_pressed():
	get_tree().change_scene("res://Main.tscn")

func _on_QUIT_pressed():
	get_tree().quit()
