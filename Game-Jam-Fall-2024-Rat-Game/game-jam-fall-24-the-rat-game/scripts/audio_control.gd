extends AudioStreamPlayer

@onready var level_music_1 = preload("res://assets/audio/RatGameBasementThemeLoop.mp3")
@onready var level_music_2 = preload("res://assets/audio/RatGameLibraryThemeLoop.mp3")
@onready var level_music_3 = preload("res://assets/audio/RatGameKitchenTheme.mp3")
@onready var main_music = preload("res://assets/audio/RatGameMainTitle.mp3")

var track = 4

func _ready() -> void:
	_play_main_music()


func _play_music(music: AudioStream, volume = 0.0):
	if stream == music:
		return
		
	stream = music
	volume_db = volume
	play()


func _play_level_music_1() -> void:
	track = 1
	_play_music(level_music_1)


func _play_level_music_2() -> void:
	track = 2
	_play_music(level_music_2)


func _play_level_music_3() -> void:
	track = 3
	_play_music(level_music_3)


func _play_main_music() -> void:
	track = 4
	_play_music(main_music)


func _play_fx(sound: AudioStream, volume = 0.0) -> void:
	var fx_player = AudioStreamPlayer.new()
	fx_player.stream = sound
	fx_player.volume_db = volume
	fx_player.name = "FX_PLAYER"
	add_child(fx_player)
	fx_player.play()
	
	await fx_player.finished
	
	fx_player.queue_free()


func _stop_music() -> void:
	stop()
