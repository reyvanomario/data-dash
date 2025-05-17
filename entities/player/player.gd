class_name Player
extends CharacterBody2D

## How much the force is increasing every frame * delta when the jetpack is activated.
const JETPACK_FORCE_INCREMENT_STEP:int = 2000
## Highest amount of force for the jetpack.
const JETPACK_MAX_FORCE:int = 5000
## Highest fall speed.
const MAX_FALL_SPEED = 1000

@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var audio_stream_player: AudioStreamPlayer2D = $AudioStreamPlayer2D


var life_gui_container

const JETPACK_PLAIN_START = preload("res://assets/original_sfx/jetpack_jet_start.wav")
const JETPACK_PLAIN_LP = preload("res://assets/original_sfx/jetpack_jet_lp.wav")
const JETPACK_PLAIN_STOP = preload("res://assets/original_sfx/jetpack_jet_stop.wav")

var magnet_active: bool = false


signal power_up_collected
signal took_damage
signal extra_life_gained
signal coin_collected


var is_dead: bool = false
var bounce_force: float = -800  # Gaya pantulan awal
var death_gravity: float = 4000  # Gravitasi saat mati
var rotation_speed: float = 400


var jetpack_force:float = 0 :
	set(f):
		if f < 0 or f > JETPACK_MAX_FORCE:
			return
		jetpack_force = f

var jetpack_activated:bool = false :
	set(a):
		if a == jetpack_activated:
			return
		
		jetpack_activated = a
		
		if jetpack_activated:
			audio_stream_player.stream = JETPACK_PLAIN_LP
			audio_stream_player.play()
		else:
			audio_stream_player.stop()
			
			audio_stream_player.stream = JETPACK_PLAIN_STOP
			audio_stream_player.play()
			jetpack_force = 0
			
var grounded:bool = false :
	set(g):
		if g == grounded:
			return
		grounded = g

@export var entry_duration: float = 1.5          # durasi tween masuk
@export var entry_target_position: Vector2 = Vector2(600, 940)
var can_move: bool = false  


func _ready() -> void:
	GameManager.game_changed.connect(on_game_changed)
	
	hurtbox_component.died.connect(on_player_died)
	
	life_gui_container = get_parent().get_node('CanvasLayer/HUD/HBoxContainer/VBoxContainer/MarginContainer3/HeartsContainer')
	
	#start_entrance()

## Used to handle input (only flying)
func _unhandled_input(event: InputEvent) -> void:
	if GameManager.game == GameManager.Game.NEW and event.is_action_pressed("fly"):
		GameManager.game = GameManager.Game.PLAYING
		start_entrance()
		return
		
	if not can_move:
		return
	
	if event.is_action('fly'):
		jetpack_activated = Input.is_action_pressed('fly')

func _process(delta: float) -> void:
	# for now, just ignore all physics if the game is over
	if not can_move or GameManager.game == GameManager.Game.OVER:
		return
	
	if jetpack_activated:
		jetpack_force += JETPACK_FORCE_INCREMENT_STEP * delta

func _physics_process(delta: float) -> void:
	if is_dead:
		velocity.x = 400
		
		# Terapkan gravitasi kematian
		velocity.y += death_gravity * delta
		
		# Putar sprite selama jatuh
		$Sprite2D.rotation_degrees += rotation_speed * delta
		
		# Pantul saat menyentuh lantai
		if is_on_floor():
			velocity.y = bounce_force
			bounce_force *= 0.6  # Kurangi gaya pantul setiap kali memantul
			if abs(bounce_force) < 50:  # Berhenti ketika pantulan kecil
				velocity = Vector2.ZERO
				#$Sprite2D.rotation_degrees = 0
				
				is_dead = false
				#set_physics_process(false)
				return
		
		velocity.x *= 0.85
		
		move_and_slide()
		
		#get_parent().get_node("ParallaxBackground").scrolling = false
		return
	
	if GameManager.game == GameManager.Game.OVER:
		return
	
	if not can_move or GameManager.game != GameManager.Game.PLAYING:
		return
	
	$Sprite2D.rotation_degrees = 0
	
	grounded = is_on_floor()
	
	if jetpack_activated:
		velocity.y = -jetpack_force
	if !jetpack_activated and not is_on_floor() and velocity.y < MAX_FALL_SPEED:
		velocity.y += get_gravity().y * delta

	move_and_slide()
	
	
## Reset the player.[br]
## Triggered by the [signal GameManagerGlobal.game] signal when set to [enum GameManagerGlobal.Game][param .NEW].
func reset():
	velocity = Vector2.ZERO
	
	jetpack_activated = false
	
	position.x = -$Sprite2D.texture.get_size().x
	position.y = entry_target_position.y
	

	hurtbox_component.health = 1
	
	QuestManager.reset_quests()
	
	

func add_extra_life():
	life_gui_container.incrementLifes(hurtbox_component.health)
	hurtbox_component.health += 1
	print("Added 1 extra life")
	
	
func on_game_changed(game: int):
	if game == GameManager.Game.NEW:
		reset()
	
	elif game == GameManager.Game.PLAYING:
		start_entrance()
	

func start_entrance() -> void:
	# Non‑aktifkan kontrol
	$Sprite2D.rotation_degrees = 0
	can_move = false
	

	# Set awal di luar layar kiri, pada ketinggian target
	position.x = -$Sprite2D.texture.get_size().x
	position.y = entry_target_position.y

	# Tween masuk ke posisi target
	create_tween() \
	  .tween_property(self, "position", entry_target_position, entry_duration) \
	  .set_trans(Tween.TRANS_SINE) \
	  .set_ease(Tween.EASE_OUT) \
	  .connect("finished", Callable(self, "_on_entrance_done"))

func _on_entrance_done() -> void:
	can_move = true
	
	GameManager.game = GameManager.Game.PLAYING
	
func on_player_died():
	if not is_dead:	
		is_dead = true
		
		# Reset rotasi dan mulai animasi
		$Sprite2D.rotation_degrees = 0
		jetpack_activated = false
		velocity = Vector2(1000, -400)  # Dorongan awal saat mati
		
		#await get_tree().create_timer(3.5).timeout
		GameManager.game = GameManager.Game.OVER
