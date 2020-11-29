extends Area2D

export (int) var direction = 1
var speed = 160

var hit = false

var fire_sound = load("res://SFX/lazer-blast.wav")
var miss_sound = load("res://SFX/lazer-miss.wav")
var hit_sound = load("res://SFX/lazer-hit.wav")

func _ready():
	SoundManager.play_sfx(fire_sound)

func _physics_process(delta):
	if(hit):
		if(!$HitExplosion.emitting):
			queue_free()
	else:
		position.x += direction * speed * delta

func _on_Lazer_body_entered(body):
	if body.is_in_group("mobs"):
		body.die()
	else:
		SoundManager.play_sfx(miss_sound)
	hit = true
	$BulletParticle.emitting = false
	monitoring = false
	$HitExplosion.emitting = true


func _on_VisibilityNotifier2D_viewport_exited(viewport):
	queue_free()
