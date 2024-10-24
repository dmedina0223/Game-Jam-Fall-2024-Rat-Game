class_name Player
extends Character

enum Wall_Direction {
	LEFT = 1,
	RIGHT = -1,
	NONE = 0,
}

const MAX_SPEED = 300.0
const GROUND_ACCELERATION = 40.0
const JUMP_VELOCITY = -600.0
const BOUNCE_VELOCITY = -500.0
const JUMP_ACCELERATION = -50.0
const CLIMB_SPEED = -100
const HORIZONTAL_AIR_ACCELERATION = 15.0
const GROUND_FRICTION = 25.0
const AIR_FRICTION = 20.0
const KNOCKBACK_HORIZONTAL = 350.0
const KNOCKBACK_VERTICAL = -250.0

var PLAYER_HAS_CONTROL: bool = true

var stun_count: int = 0
var is_in_climbable_area: bool = false
var is_climbing: bool = false
var touching_wall: bool = true
var wall_currently_on: Wall_Direction = Wall_Direction.NONE 

@onready var jump_sfx = preload("res://assets/audio/RatGame_jump_sfx.mp3")
@onready var hurt_sfx = preload("res://assets/audio/RatGame_hurt_sfx.mp3")
@onready var bounce_sfx = preload("res://assets/audio/RatGame_landingenemy_sfx.mp3")
@onready var stun_part = preload("res://scenes/stunparticles.tscn")


func _physics_process(delta: float) -> void:
	touching_wall = is_on_wall()
	# Add the gravity.
	if not is_on_floor() and not is_climbing:
		velocity += get_gravity() * delta
		
	var direction := Input.get_axis("left", "right")

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor() and PLAYER_HAS_CONTROL:
		velocity.y = JUMP_VELOCITY
		AudioControl._play_fx(jump_sfx, -12.0)


	if direction and PLAYER_HAS_CONTROL and !is_climbing:
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
	# Handle climbing
	if is_climbing:
		if Input.is_action_just_pressed("Jump"):
			velocity.x = MAX_SPEED * wall_currently_on
			velocity.y = JUMP_VELOCITY * 0.8
		elif direction:
			velocity.y = CLIMB_SPEED * direction * wall_currently_on * -1
			velocity.x = 0
		else:
			velocity.y = 0
			velocity.x = 0
			
	if PLAYER_HAS_CONTROL:
		if is_on_floor():
			if is_zero_approx(velocity.x):
				state_machine.travel("Idle")
			else:
				state_machine.travel("Running")
		else:
			if is_climbing:
				if is_zero_approx(velocity.y):
					state_machine.travel("Idle")
				else:
					state_machine.travel("Running")
			else:
				if velocity.y < 0:
					state_machine.travel("Jump")
				else:
					state_machine.travel("Fall")
	change_rotation(calculate_rotation())
	move_and_slide()


func calculate_rotation() -> float:
	var angle: float = 0.0
	angle = (wall_currently_on * PI/2) - sprite.global_rotation # left is -1 (counterclockwise), right is 1 (clockwise)
	if not is_climbing:
		angle = 0 - sprite.global_rotation
	if is_climbing and facing == wall_currently_on: 
		change_facing()
	return angle


func take_knockback() -> void:
	PLAYER_HAS_CONTROL = false
	is_climbing = false
	stun_count += 1
	if stun_count < 5:
		velocity.x = KNOCKBACK_HORIZONTAL * facing * -1
		velocity.y = KNOCKBACK_VERTICAL
		AudioControl._play_fx(hurt_sfx, -12.0)
		state_machine.travel("Stun")
	$KBTimer.start(3)


func bounce() -> void:
	print_debug("bounce")
	AudioControl._play_fx(bounce_sfx, -12.0)
	#add_child(stun_part.instantiate())
	velocity.y = BOUNCE_VELOCITY


func start_climb() -> void:
	if PLAYER_HAS_CONTROL:
		is_climbing = true


func _on_kb_timer_timeout() -> void:
	PLAYER_HAS_CONTROL = true
	state_machine.travel("Idle")
	stun_count = 0
