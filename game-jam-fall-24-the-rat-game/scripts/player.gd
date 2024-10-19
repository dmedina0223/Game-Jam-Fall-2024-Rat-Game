class_name Player
extends Character

const MAX_SPEED = 330.0
const GROUND_ACCELERATION = 40.0
const JUMP_VELOCITY = -400.0
const JUMP_ACCELERATION = -50.0
const HORIZONTAL_AIR_ACCELERATION = 20.0
const GROUND_FRICTION = 25.0
const AIR_FRICTION = 20.0
const KNOCKBACK_HORIZONTAL = 200.0
const KNOCKBACK_VERTICAL = -200.0

var PLAYER_HAS_CONTROL = true



func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor() and PLAYER_HAS_CONTROL:
		velocity.y = JUMP_VELOCITY
		jumping = true

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction and PLAYER_HAS_CONTROL:
		if is_on_floor():
			if velocity.x < MAX_SPEED:
				velocity.x += direction * GROUND_ACCELERATION
		else:
			if velocity.x < MAX_SPEED:
				velocity.x += direction * HORIZONTAL_AIR_ACCELERATION
		if velocity.x > MAX_SPEED or velocity.x * -1 > MAX_SPEED:
				velocity.x = direction * MAX_SPEED
				
	else:
		velocity.x = move_toward(velocity.x, 0, GROUND_FRICTION)
	if is_on_floor():
		jumping = true
	move_and_slide()

func take_knockback():
	PLAYER_HAS_CONTROL = false

	velocity.x = KNOCKBACK_HORIZONTAL 
	velocity.y = KNOCKBACK_VERTICAL 
	
	$KBTimer.start(3)


func _on_kb_timer_timeout() -> void:
	PLAYER_HAS_CONTROL = true
	pass # Replace with function body.
