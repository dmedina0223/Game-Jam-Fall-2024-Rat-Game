extends Area2D

enum Wall_Direction{
	LEFT = 1, #to the left of player when climbing it
	RIGHT = -1, #to the right of player when climbing it
	NONE = 0,
}

@export var wall_direction = Wall_Direction.NONE


func _on_area_entered(area: Area2D) -> void:
	print_debug("climb")
	if area.owner is Player:
		area.owner.start_climb()
		area.owner.wall_currently_on = wall_direction
		area.owner.sprite.position.x -= wall_direction * 7


func _on_area_exited(area: Area2D) -> void:
	print_debug("Exit")
	if area.owner is Player:
		area.owner.is_climbing = false
		area.owner.is_in_climbable_area = false
		area.owner.sprite.position.x += wall_direction * 7
		area.owner.wall_currently_on = Wall_Direction.NONE
