extends AudioStreamPlayer


var game_music_audio = preload("res://assets/compfest/music/HeatleyBros - HeatleyBros II - 08 8 Bit Scrap.mp3")
var main_menu_music_audio = preload("res://assets/compfest/music/HeatleyBros - HeatleyBros III - 03 8 Bit Select.mp3")

func _ready() -> void:
	finished.connect(on_finished)
	$Timer.timeout.connect(on_timer_timeout)
	

func play_main_menu_music():
	volume_db = -15
	stream = main_menu_music_audio
	play()
	
	
func play_game_music():
	stream = game_music_audio
	play()
	

func on_finished():
	$Timer.start()
	

func on_timer_timeout():
	play()
	
