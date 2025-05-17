class_name PowerUpCollectibles
extends Node2D


var extra_life_png = preload("res://assets/compfest/Items&obstacles (glow)/Hearts.PNG")
var magnet_png = preload("res://assets/compfest/Items&obstacles (glow)/Magnet.PNG")
var multiplier_png = preload("res://assets/compfest/ScoreMultiplier.PNG")

@onready var spawnable: Spawnable = $Spawnable
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var collectable_2d: Collectable2D = $Collectable2D

@export var powerup_pool: Array[PowerUp]

var powerup_data: PowerUp = null
 
var scrolling:bool = true :
	set(s):
		if s == scrolling: return
		scrolling = s
		
var speed: int = 0
var amplitude: float = 1.0 
var frequency: float = 2.0   
var time: float = 0.0 

signal screen_entered

func _ready() -> void:
	
	GameManager.game_changed.connect(func(game:int):
		match game:
			GameManager.Game.OVER:
				scrolling = false
			GameManager.Game.NEW:
				scrolling = false
				spawnable.despawn.call_deferred()
			GameManager.Game.PLAYING:
				scrolling = true
	)
	
	
	visible_on_screen_notifier_2d.screen_entered.connect(func(): self.screen_entered.emit())
	visible_on_screen_notifier_2d.screen_exited.connect(func(): spawnable.despawn.call_deferred())
	
	spawnable.root_node = self
	
	
	collectable_2d.collected.connect(on_collected)
	
	pick_powerup()
	
	print(powerup_data.name)
	
	

func _process(delta: float) -> void:
	if scrolling:
		position.x += (-GameManager.speed - speed) * delta
		
		#time += delta
		#
		#position.y = self.position.y + sin(time * frequency) * amplitude
		

func pick_powerup():
	powerup_data = powerup_pool.pick_random()
	
	if powerup_data.id == "magnet":
		$Sprite2D.texture = magnet_png
		$AnimationPlayer.stop()
		$AnimationPlayer.play("magnet_default")
		
	elif powerup_data.id == "extra_life":
		$Sprite2D.texture = extra_life_png
		$AnimationPlayer.stop()
		$AnimationPlayer.play("heart_default")
		
	elif powerup_data.id == "multiplier":
		$Sprite2D.texture = multiplier_png
		$AnimationPlayer.stop()
		$AnimationPlayer.play("multiplier_default")
		
		
func on_collected() -> void:
	#$RandomStreamPlayerComponent.play_random()
	
	var player = get_tree().get_first_node_in_group("player")
	
	if player:
		
		if powerup_data.id == "magnet":
			player.get_node("PowerUpManager/MagnetController").call_deferred("activate_magnet")
		elif powerup_data.id == "extra_life":
			player.add_extra_life()
		elif powerup_data.id == "multiplier":
			GameManager.activate_score_multiplier(10.0)
			
	spawnable.despawn.call_deferred()
