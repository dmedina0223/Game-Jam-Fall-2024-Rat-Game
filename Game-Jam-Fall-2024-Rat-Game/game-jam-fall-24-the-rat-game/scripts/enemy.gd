class_name Enemy
extends Character

const KNOCKBACK_DISTANCE = 300
const AIR_FRICTION = 20.0
const MOVE_SPEED = 2.0

var stunned = false
var start_pos:Vector2


func _ready() -> void:
	start_pos = global_position
	print_debug(start_pos)


func _physics_process(delta: float) -> void:
	if !stunned:
		global_position.y = move_toward(global_position.y, start_pos.y, MOVE_SPEED)
	velocity.y = move_toward(velocity.y, 0, AIR_FRICTION)
	move_and_slide()


func _on_hit_box_area_entered(area: Area2D) -> void:
	print_debug("Hit")
	if area.get_owner().has_method("take_knockback"):
		area.owner.take_knockback()


func _on_jump_box_area_entered(area: Area2D) -> void:
	print_debug("jump")
	if area.get_owner().has_method("bounce"):
		area.owner.bounce()
		stunned = true
		state_machine.travel("Stun")
		$StunTimer.start(2)
		velocity.y = KNOCKBACK_DISTANCE


func _on_stun_timer_timeout() -> void:
	state_machine.travel("Idle")
	stunned = false
