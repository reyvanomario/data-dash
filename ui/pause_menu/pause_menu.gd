class_name PauseMenu
extends Control




@export var audio_paused: AudioStream

@export var audio_select: AudioStream


@onready var audio_bus_sfx_index: int = AudioServer.get_bus_index('sfx')

@onready var audio_bus_music_index: int = AudioServer.get_bus_index('music')


@onready var home_button: Button = $VBoxContainer/VBoxContainer/home_button

@onready var restart_button: Button = $VBoxContainer/VBoxContainer/restart_button

@onready var resume_button: Button = $VBoxContainer/VBoxContainer/resume_button

@onready var audio_stream_player: AudioStreamPlayer = $RandomStreamPlayerComponent

var _input_locked := false


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('ui_cancel') and GameManager.game == GameManager.Game.PLAYING:
		GameManager.paused = !GameManager.paused
		get_viewport().set_input_as_handled()
		if GameManager.paused:
			return


func _ready() -> void:
	GameManager.paused_changed.connect(on_paused_changed)
	home_button.pressed.connect(on_home_button_pressed)
	resume_button.pressed.connect(on_resume_button_pressed)
	restart_button.pressed.connect(on_restart_button_pressed)
	


func on_home_button_pressed() -> void:
	if _input_locked:
		return
		
	_input_locked = true
	
	audio_stream_player.play_random()
	await audio_stream_player.finished
	
	GameManager.game = GameManager.Game.NEW
	get_tree().change_scene_to_file("res://ui/menu/main_menu.tscn")
	MusicPlayer.play_main_menu_music()
	GameManager.paused = false



func on_paused_changed(paused: bool) -> void:
	visible = paused
	if !paused:
		return
		
	audio_stream_player.play_random()
	_input_locked = false


func on_restart_button_pressed() -> void:
	if _input_locked:
		return
		
	_input_locked = true
	audio_stream_player.play_random()
	
	await audio_stream_player.finished
	GameManager.game = GameManager.Game.NEW
	GameManager.game = GameManager.Game.PLAYING
	GameManager.paused = false


func on_resume_button_pressed() -> void:
	if _input_locked:
		return
		
	_input_locked = true
	audio_stream_player.play_random()
	
	GameManager.paused = false


	
