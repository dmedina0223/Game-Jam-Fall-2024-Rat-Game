class_name Player
extends Character

const MAX_SPEED = 330.0
const GROUND_ACCELERATION = 40.0
const JUMP_VELOCITY = -600.0
const JUMP_ACCELERATION = -50.0
const HORIZONTAL_AIR_ACCELERATION = 15.0
const GROUND_FRICTION = 25.0
const AIR_FRICTION = 20.0
const KNOCKBACK_HORIZONTAL = 200.0
const KNOCKBACK_VERTICAL = -200.0

var PLAYER_HAS_CONTROL = true

@onready var jump_sfx = preload("res://assets/audio/test.mp3")


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor() and PLAYER_HAS_CONTROL:
		velocity.y = JUMP_VELOCITY
		AudioControl._play_fx(jump_sfx, -12.0)
		#jumping = true

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction and PLAYER_HAS_CONTROL:
		if is_on_floor():
			velocity.x += direction * GROUND_ACCELERATION
			if direction != facing:
				change_facing()
		else:
			velocity.x += direction * HORIZONTAL_AIR_ACCELERATION
		if abs(velocity.x) > MAX_SPEED:
				velocity.x = direction * MAX_SPEED
	else:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, GROUND_FRICTION)
		else:
			velocity.x = move_toward(velocity.x, 0, AIR_FRICTION)
	if PLAYER_HAS_CONTROL:
		if is_on_floor():
			if is_zero_approx(velocity.x):
				state_machine.travel("Idle")
			else:
				state_machine.travel("Running")
		else:
			if velocity.y < 0:
				state_machine.travel("Jump")
			else:
				state_machine.travel("Fall")
	move_and_slide()

func take_knockback():
	PLAYER_HAS_CONTROL = false

	velocity.x = KNOCKBACK_HORIZONTAL * facing * -1
	velocity.y = KNOCKBACK_VERTICAL
	state_machine.travel("Stun")
	
	$KBTimer.start(3)


func _on_kb_timer_timeout() -> void:
	PLAYER_HAS_CONTROL = true
	state_machine.travel("Idle")
	pass # Replace with function body.
