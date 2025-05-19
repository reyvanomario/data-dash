extends Node2D

@export var speed_min: float = 200.0  # kecepatan min
@export var speed_max: float = 300.0  # kecepatan max
@export var y_min: float = 100.0      # batas bawah spawn
@export var y_max: float = 400.0      # batas atas spawn


@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var spawnable: Node2D = $Spawnable

var target: Node2D = null

var velocity: Vector2
var speed: int = 700

var scrolling:bool = false :
	set(s):
		if s == scrolling: return
		scrolling = s
		


signal screen_entered
		
		

func _ready() -> void:
	GameManager.game_changed.connect(func(game:int):
		match game:
			GameManager.Game.OVER:
				scrolling = false
				$RandomStreamPlayer2DComponent.stop()
			GameManager.Game.NEW:
				scrolling = false
				spawnable.despawn.call_deferred()
	)
	
	visible_on_screen_notifier_2d.screen_entered.connect(func(): self.screen_entered.emit())
	visible_on_screen_notifier_2d.screen_exited.connect(func(): spawnable.despawn.call_deferred();$RandomStreamPlayer2DComponent.stop())
	
	spawnable.root_node = self
	spawnable.spawned.connect(on_spawned)
	spawnable.despawned.connect(on_despawned)
	


func _process(delta: float) -> void:
	if scrolling:
		position.x += (-GameManager.speed - speed) * delta



func on_spawned(_spawn_point: Vector2, target_node: Node2D) -> void:
	target = target_node
	
	
	if GameManager.game == GameManager.Game.OVER:
		$RandomStreamPlayer2DComponent.stop()
		return
	

	scrolling = true
	
	$RandomStreamPlayer2DComponent.play_random()



func on_despawned(_new_position: Vector2) -> void:
	$RandomStreamPlayer2DComponent.stop()
	scrolling = false
