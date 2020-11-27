extends Area2D

enum STATES {
	REPAIRING_0,
	REPAIRING_1,
	REPAIRING_2,
	REPAIRED
}

var item_return_sound = load("res://SFX/return-pickup.wav")

var state

func _ready():
	set_state(STATES.REPAIRING_0)

func set_state(new_state):
	match new_state:
		STATES.REPAIRING_0:
			$AnimatedSprite.play("default")
			$Smoke/Smoke1.emitting = true
			$Smoke/Smoke2.emitting = true
			$Smoke/Smoke3.emitting = true
			$Smoke/Smoke4.emitting = true
			state = new_state
		STATES.REPAIRING_1:
			$AnimatedSprite.play("repairing_1")
			$Smoke/Smoke1.emitting = true
			$Smoke/Smoke2.emitting = true
			$Smoke/Smoke3.emitting = false
			$Smoke/Smoke4.emitting = true
			state = new_state
		STATES.REPAIRING_2:
			$AnimatedSprite.play("repairing_2")
			$Smoke/Smoke1.emitting = false
			$Smoke/Smoke2.emitting = false
			$Smoke/Smoke3.emitting = false
			$Smoke/Smoke4.emitting = true
			state = new_state
		STATES.REPAIRED:
			$AnimatedSprite.play("repaired")
			$Smoke/Smoke1.emitting = false
			$Smoke/Smoke2.emitting = false
			$Smoke/Smoke3.emitting = false
			$Smoke/Smoke4.emitting = false
			state = new_state

func launch(delta):
	position.y -= delta * 128
	
func _process(delta):
	if state == STATES.REPAIRED:
		launch(delta)

func _on_Rocket_body_entered(body):
	if body.is_in_group("player"):
		print("ROCKET")
		if body.has_item:
			SoundManager.play_sfx(item_return_sound)
			print("RETURNED")
			body.has_item = false
			body.items_returned += 1
			set_state(state + 1)
