extends CanvasLayer

var current_lives = 0
var lives_icon = load("res://ui/ui.life.png")

func set_jetpack_percent(v):
	$Theme/JetPack/ProgressBar.value = v

func set_fire_percent(v):
	$Theme/Laser/ProgressBar.value = 1.0 - v
	
func set_current_lives(new_lives):
	if(new_lives == current_lives):
		return
	current_lives = new_lives
	
	#empty
	for k in $Theme/Lives/Icons.get_children():
		$Theme/Lives/Icons.remove_child(k)

	#add
	for i in current_lives:
		var l = TextureRect.new()
		l.texture = lives_icon
		$Theme/Lives/Icons.add_child(l)
