class_name Character
extends CharacterBody2D

signal CharacterDirectionChange(facing:Facing)


enum Facing { 
	LEFT = -1,
	RIGHT = 1,
}

const TERMINAL_VELOCITY = 700
const DEFAULT_JUMP_VELOCITY = -400
const DEFAULT_MOVE_VELOCITY = 300

var movement_speed = DEFAULT_MOVE_VELOCITY
var jump_velocity = DEFAULT_JUMP_VELOCITY

#var right_cmd : Command
#var left_cmd : Command
#var up_cmd : Command
#var idle : Command

var facing:Facing = Facing.LEFT

var jumping:bool = false
var gravity: int = ProjectSettings.get("physics/2d/default_gravity")

var _horizontal_input : float

@onready var animation_player:AnimationPlayer = $AnimationPlayer
@onready var sprite:Sprite2D = $Sprite2D
@onready var state_machine:AnimationNodeStateMachinePlayback = $AnimationTree["parameters/playback"]
func _ready() -> void:
	jumping = false
	change_facing()


func _physics_process(delta: float) -> void: 
	_apply_gravity(delta)
	_apply_movement(delta)


func _apply_movement(_delta: float):
	move_and_slide()


func _apply_gravity(delta : float) -> void:
	velocity.y = minf(TERMINAL_VELOCITY, velocity.y + gravity * delta)


func move(value: float) -> void:
	_horizontal_input = value


func change_facing() -> void:
	if facing == Facing.LEFT:
		facing = Facing.RIGHT
		sprite.flip_h = false
	else:
		facing = Facing.LEFT
		sprite.flip_h = true
	emit_signal("CharacterDirectionChange", facing)

#This function is meant to be called in the AnimationController after the each relevant anmiation has concluded.
#func clear_action_state() -> void:


func command_callback(_name:String) -> void:
	pass
