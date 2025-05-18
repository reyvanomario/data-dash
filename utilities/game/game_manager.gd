class_name GameManagerGlobal
extends Node


const METERS_PER_SECOND:int = 2



enum Game {
	OVER,
	NEW,
	PLAYING,
}


enum Speed {
	RESET = 0,
	STEP = 10,
	START = 400,
	MAX = 2000,
}

var character_speed: float = 0.0


var game: int = Game.NEW :
	set(g):
		if g == game:
			return
				
		game = g
		
		match game:
			Game.OVER:
				speed = Speed.RESET

			Game.NEW:
				speed = Speed.RESET
				distance = 0
				coins = 0
			Game.PLAYING:
				speed = Speed.START

		
		game_changed.emit(game)

var paused: bool = false :
	set(p):
		paused = p
		paused_changed.emit(paused)
		get_tree().paused = paused
		
		

var speed: float = Speed.RESET :
	set(s):
		if s > Speed.MAX:
			return
		speed = s


var distance: float = 0.0 :
	set(d):
		if d < 0:
			return
		distance = d
		distance_changed.emit(distance)


var coins: int = 0 :
	set(c):
		if c < 0:
			return
		coins = c
		coins_changed.emit(coins)
		
var quest_bonus: int = 0


var score_multiplier: int = 1
		
var multiplier_active: bool = false

@onready var multiplier_timer: Timer = Timer.new()

signal game_changed(game: int)
signal paused_changed(paused: bool)
signal distance_changed(distance: float)
signal coins_changed(coins: int)
signal multiplier_activated
signal distance_increased(distance: float)


func _unhandled_input(event: InputEvent) -> void:
	#if game == Game.NEW and event.is_action_pressed('fly'):
		#game = Game.PLAYING
		
	if event.is_action_pressed('ui_cancel') and game == Game.PLAYING:
		paused = !paused
	#get_viewport().set_input_as_handled()


func _ready() -> void:
	add_child(multiplier_timer)
	multiplier_timer.timeout.connect(_on_multiplier_timeout)


func _process(delta: float) -> void:
	if game == Game.PLAYING:
		speed += Speed.STEP * delta
		var prev_distance = distance
		distance += (METERS_PER_SECOND * delta) * (speed / Speed.START) * score_multiplier
		
		if floor(distance / 100) > floor(prev_distance / 100):
			distance_increased.emit(distance)
			
			
	elif game == Game.OVER:
		speed = lerp(float(speed), float(Speed.RESET), delta * 2.0)
		distance += (METERS_PER_SECOND * delta) * (speed / Speed.START)

	
func activate_score_multiplier(duration: float):
	multiplier_active = true
	score_multiplier += 0.5
	multiplier_timer.start(duration)
	
	multiplier_activated.emit()
	

func _on_multiplier_timeout():
	multiplier_active = false
	score_multiplier = 1	
