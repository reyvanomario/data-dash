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

var _displayed_score: int = 0

var displayed_score: int:
	get:
		return _displayed_score
	set(val):
		_displayed_score = val
		label_score.text = str(val)
		


func _ready() -> void:
	GameManager.game_changed.connect(on_game_changed)
	#button_continue.pressed.connect(on_continue)
	home_button.pressed.connect(on_home)
	restart_button.pressed.connect(on_restart)
		

func on_game_changed(game: int) -> void:
	match game:
		GameManager.Game.NEW:
			visible = false
			MusicPlayer.volume_db = -10
			
		GameManager.Game.OVER:
			
			await get_tree().create_timer(1.5).timeout
			
			visible = true
			animation_player.play("transition_in")
			
			MusicPlayer.volume_db = -23
			
			label_distance.text = "%d" % floori(GameManager.distance)
			label_coins.text = "%d" % floori(GameManager.coins)
			
			var quest_bonus = GameManager.quest_bonus
			quest_bonus_label.text = str(quest_bonus)
			
			
			
			var final_score = floori(GameManager.distance + (0.5 * GameManager.coins) + quest_bonus)
		
			#label_score.text = "Final Score %d" % final_score
			count_up_score(final_score, 1.5)

func on_home() -> void:
	GameManager.game = GameManager.Game.NEW
	


# restart
func on_restart() -> void:
	GameManager.game = GameManager.Game.NEW; GameManager.game = GameManager.Game.PLAYING


func play_audio(audio_stream: AudioStream) -> void:
	if audio_stream == null:
		return
	audio_stream_player.stream = audio_stream
	audio_stream_player.play()
	
func count_up_score(target: int, duration: float = 0.5) -> void:
	await get_tree().create_timer(1.3).timeout
	
	create_tween() \
	  .tween_property(self, "displayed_score", target, duration) \
	  .set_trans(Tween.TRANS_SINE) \
	  .set_ease(Tween.EASE_OUT)
	
