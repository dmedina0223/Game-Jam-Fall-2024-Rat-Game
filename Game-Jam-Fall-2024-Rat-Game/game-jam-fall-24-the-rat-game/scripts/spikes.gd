extends Area2D

func _on_area_entered(area: Area2D) -> void:
	if area.get_owner().has_method("take_knockback"):
		area.owner.take_knockback()
