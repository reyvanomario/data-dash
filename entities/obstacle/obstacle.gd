class_name Obstacle
extends Area2D

signal spawned
signal disabled
signal screen_entered

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

var possible_spawn_points: Array[Vector2] = [Vector2(2000, 0)]

var enabled: bool = false :
	set(e):
		if e == enabled:
			return
		
		enabled = e
		
		if enabled:
			spawn()
		else:
			disable()
var speed: int = 0
## Is the game playing and scrolling?
var scrolling:bool = true :
	set(s):
		if s == scrolling: return
		scrolling = s

func _ready():
	GameManager.game_changed.connect(func(game:int):
		match game:
			GameManager.Game.OVER:
				scrolling = false
			GameManager.Game.NEW:
				scrolling = false
				self.enabled = false
			GameManager.Game.PLAYING:
				scrolling = true
	)
	
	visible_on_screen_notifier_2d.screen_entered.connect(func(): self.screen_entered.emit())
	visible_on_screen_notifier_2d.screen_exited.connect(func(): self.enabled = false)
	
	body_entered.connect(func(body: Node2D):
		if body is Player:
			GameManager.game = GameManager.Game.OVER
	)

func _process(delta: float) -> void:
	if scrolling:
		position.x += (-GameManager.speed + speed) * delta

func disable() -> void:
	visible = false
	process_mode = ProcessMode.PROCESS_MODE_DISABLED
	disabled.emit()

func spawn() -> void:
	position = possible_spawn_points.pick_random()
	visible = true
	process_mode = ProcessMode.PROCESS_MODE_INHERIT
	spawned.emit()
