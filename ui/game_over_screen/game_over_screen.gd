class_name GameOverScreen
extends Control

@export var audio_select: AudioStream

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer



@onready var label_coins: Label = $coins
@onready var label_distance: Label = $distance
@onready var quest_bonus_label: Label = $QuestBonusLabel
@onready var label_score: Label = $score


@onready var home_button = $HBoxContainer/MarginContainer/VBoxContainer/home_button
@onready var restart_button: Button = $HBoxContainer/MarginContainer/VBoxContainer/restart_button

@onready var animation_player = $AnimationPlayer

@onready var response_label: Label = $%SendCodeResponseLabel


var _displayed_score: int = 0

var displayed_score: int:
	get:
		return _displayed_score
	set(val):
		_displayed_score = val
		label_score.text = str(val)
		

@onready var try_again_sprite: AnimatedSprite2D = $TryAgainSprite
@onready var exit_selected_sprite: AnimatedSprite2D = $ExitSelectedSprite


var current_selection: int = 0

var can_handle_input: bool = false


var background_1_png = preload("res://assets/compfest/Menus/gameover-bg-1.PNG")
var background_2_png = preload("res://assets/compfest/Menus/gameover-bg-2.PNG")
var background_3_png = preload("res://assets/compfest/Menus/gameover-bg-3.PNG")
var background_full_png = preload("res://assets/compfest/Menus/Bg-gameover resized.png")


func _ready() -> void:
	GameManager.game_changed.connect(on_game_changed)

	home_button.pressed.connect(on_home)
	restart_button.pressed.connect(on_restart)
	
	GlobalGamePointSender.request_failed.connect(on_request_failed)
	GlobalGamePointSender.send_point_succeed.connect(on_send_point_succeed)
	GlobalGamePointSender.send_point_failed.connect(on_send_point_failed)
	
	#update_menu_display()
		

func on_game_changed(game: int) -> void:
	match game:
		GameManager.Game.NEW:
			visible = false
			MusicPlayer.volume_db = -15
			
		GameManager.Game.OVER:
			
			await get_tree().create_timer(1.8).timeout
			
			visible = true
			
			MusicPlayer.volume_db = -25
			
			animation_player.play("transition_in")
			
			
			
			label_distance.text = "%d" % floori(GameManager.distance)
			label_coins.text = "%d" % floori(GameManager.coins)
			
			var quest_bonus = GameManager.quest_bonus
			quest_bonus_label.text = str(quest_bonus)
			
			
			
			
			var final_score = floori((GameManager.distance + (0.2 * GameManager.coins) \
			 + quest_bonus)/2)
			
			# send poin ke compfest
			GlobalGamePointSender.send_point(final_score)
			
			await animation_player.animation_finished
			
		
			#label_score.text = "Final Score %d" % final_score
			await count_up_score(final_score, 1.5)
			
			can_handle_input = true
			

func on_home() -> void:
	GameManager.game = GameManager.Game.NEW
	


# restart
func on_restart() -> void:
	label_coins.text = "0"
	label_distance.text = "0"
	quest_bonus_label.text = "0"
	label_score.text = "0"
	_displayed_score = 0
	displayed_score = 0
	
	GameManager.game = GameManager.Game.NEW; GameManager.game = GameManager.Game.PLAYING
	

	
	
func count_up_score(target: int, duration: float = 0.5) -> void:
	await get_tree().create_timer(1.3).timeout
	
	create_tween() \
	  .tween_property(self, "displayed_score", target, duration) \
	  .set_trans(Tween.TRANS_SINE) \
	  .set_ease(Tween.EASE_OUT)
	
	



func _input(event):
	if GameManager.game != GameManager.Game.OVER || !can_handle_input:
		return
	
		
	if event.is_action_pressed("ui_left") || event.is_action_pressed("ui_right"):
		current_selection = 1 - current_selection  
		
		update_menu_display()

		
		
	if event.is_action_pressed("ui_accept"):
		$RandomStreamPlayerComponent.play_random()
		await $RandomStreamPlayerComponent.finished
		
		handle_selection()
		can_handle_input = false


func update_menu_display():
	match current_selection:
		0:
			$TryAgainSprite.visible = true
			$ExitSelectedSprite.visible = false
		1:
			$TryAgainSprite.visible = false
			$ExitSelectedSprite.visible = true




func handle_selection():
	if GameManager.game != GameManager.Game.OVER:
		return
		
	match current_selection:
		0:
			ScreenTransition.transition()
			await ScreenTransition.transitioned_halfway
			
			GameManager.game = GameManager.Game.NEW
			get_tree().change_scene_to_file("res://ui/menu/main_menu.tscn")
			MusicPlayer.play_main_menu_music()
			

		1:
			get_tree().quit()
			

func on_request_failed(error_messages: String):
	response_label.text = error_messages
	response_label.add_theme_color_override("font_color", Color.RED)
	response_label.visible = true
	

func on_send_point_succeed(response_messages: String, added_point: int):
	response_label.text = response_messages + ": " + str(added_point)
	response_label.add_theme_color_override("font_color", Color.GREEN)
	response_label.visible = true
	
	
func on_send_point_failed(error_messages: String):
	response_label.text = error_messages
	response_label.add_theme_color_override("font_color", Color.RED)
	response_label.visible = true
	
