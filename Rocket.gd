extends Area2D

enum STATES {
	REPAIRING_0,
	REPAIRING_1,
	REPAIRING_2,
	REPAIRED
}

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
