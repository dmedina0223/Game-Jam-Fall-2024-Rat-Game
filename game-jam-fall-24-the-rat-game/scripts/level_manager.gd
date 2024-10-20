extends Node

const CAMERA_HEIGHT = 768
const CAMERA_WIDTH = 1024

@onready var camera = $Camera2D
@onready var player = %Player
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioControl._play_level_music()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player.global_position.y <= camera.global_position.y - CAMERA_HEIGHT / 2:
		print_debug("Up")
		camera.global_position.y -= CAMERA_HEIGHT
	else:
		if player.global_position.y >= camera.global_position.y + CAMERA_HEIGHT / 2:
			print_debug("Down")
			camera.global_position.y += CAMERA_HEIGHT
	pass
