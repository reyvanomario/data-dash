class_name Coin
extends Node2D


@onready var collectable_2d: Collectable2D = $Collectable2D
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var spawnable: Spawnable = $Spawnable

var velocity: Vector2 = Vector2.ZERO

var speed: int = 0
var scrolling:bool = true :
	set(s):
		if s == scrolling: return
		scrolling = s
		
		
var is_visible: bool = false


var coin_quest: Quest
var quest_coint_collected: int = 0



signal screen_entered


func _ready():
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
	
	collectable_2d.collected.connect(on_collected)
	
	visible_on_screen_notifier_2d.screen_entered.connect(func(): 
		is_visible = true
		self.screen_entered.emit()
	)
	visible_on_screen_notifier_2d.screen_exited.connect(func():
		is_visible = false
		spawnable.despawn.call_deferred()
	)
	
	spawnable.root_node = self

func _process(delta: float) -> void:
	if scrolling:
		position.x += (-GameManager.speed - speed) * delta
		
func _physics_process(delta: float) -> void:
	var player = get_tree().get_first_node_in_group("player")
	if is_visible and player.magnet_active:
		if self in player.get_node("MagnetAbility").collectibles_in_range:
			position += velocity * delta
			velocity = velocity.lerp(Vector2.ZERO, 0.1)


func on_collected() -> void:
	GameManager.coins += 1
		
	spawnable.despawn.call_deferred()
