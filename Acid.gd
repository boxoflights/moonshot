extends KinematicBody2D

var speed = 128
var direction = Vector2.DOWN
var lifetime = 10
var landed = false
var hit = false

var drop_sound = load("res://SFX/acid-drop.wav")

func _ready():
	SoundManager.play_sfx(drop_sound)

func _physics_process(delta):
	move_and_slide(direction * speed, Vector2.UP)
	
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.is_in_group("tiles"):
			if !landed:
				$CPUParticles2D.visible = false
				$AnimatedSprite.visible = true
				$AnimatedSprite.animation = 'splash'
				landed = true
	
	if hit:
		var p = get_tree().get_current_scene().get_node("Player")
		if p:
			p.take_damage(5 * delta)
	
	if lifetime > 0:
		lifetime -= delta
	else:
		queue_free()


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == 'splash':
		$AnimatedSprite.animation = 'default'


func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		hit = true


func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		hit = false
