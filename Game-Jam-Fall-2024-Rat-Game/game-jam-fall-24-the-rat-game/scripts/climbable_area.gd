class_name ClimbableArea
extends Area2D

enum Wall_Direction{
	LEFT = 1, #to the left of player when climbing it
	RIGHT = -1, #to the right of player when climbing it
	NONE = 0,
}

@export var wall_direction: Wall_Direction = Wall_Direction.NONE


func _init() -> void:
	collision_layer = 0
	collision_mask = 8
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)


func _on_area_entered(hurtbox: HurtBox) -> void:
	print_debug("climb")
	hurtbox.owner.is_in_climbable_area = true
	hurtbox.owner.wall_currently_on = wall_direction
	
	
func _on_area_exited(hurtbox: HurtBox) -> void:
	hurtbox.owner.is_climbing = false
	hurtbox.owner.is_in_climbable_area = false
	hurtbox.owner.wall_currently_on = Wall_Direction.NONE
	hurtbox.owner.change_facing()
