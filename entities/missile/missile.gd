class_name Missile
extends Node2D

@export var audio_launch: AudioStream
@export var audio_warning: AudioStream


@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

@onready var spawnable: Spawnable = $Spawnable

@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

@onready var warning_animation_sprite: AnimatedSprite2D = $warning_animation_sprite

@onready var warning_timer: Timer = $warning_timer

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


var aiming: bool = true
var speed: int = 1000
var scrolling:bool = false :
	set(s):
		if s == scrolling: return
		scrolling = s

var target: Node2D = null

var warning_time_low: float = 2.0



signal screen_entered



func _ready() -> void:
	GameManager.game_changed.connect(func(game:int):
		match game:
			GameManager.Game.OVER:
				aiming = false
				scrolling = false
			GameManager.Game.NEW:
				aiming = false
				scrolling = false
				spawnable.despawn.call_deferred()
	)
	
	visible_on_screen_notifier_2d.screen_entered.connect(func(): self.screen_entered.emit())
	visible_on_screen_notifier_2d.screen_exited.connect(func(): spawnable.despawn.call_deferred())
	
	spawnable.root_node = self
	spawnable.spawned.connect(on_spawned)
	spawnable.despawned.connect(on_despawned)

func _process(delta: float) -> void:
	if scrolling:
		position.x += (-GameManager.speed - speed) * delta
	if aiming and target != null:
		position.y = lerpf(position.y, target.position.y, 0.1)



func on_spawned(_spawn_point: Vector2, target_node: Node2D) -> void:
	target = target_node
	warning_timer.start(warning_time_low)
	await warning_timer.timeout
	
	if GameManager.game == GameManager.Game.OVER:
		return
	
	warning_animation_sprite.animation = 'warning_high'
	audio_stream_player_2d.stream = audio_warning
	audio_stream_player_2d.play()
	await audio_stream_player_2d.finished
	
	if GameManager.game == GameManager.Game.OVER:
		return
	
	warning_animation_sprite.visible = false
	aiming = false
	scrolling = true
	audio_stream_player_2d.stream = audio_launch
	audio_stream_player_2d.play()


func on_despawned(_new_position: Vector2) -> void:
	aiming = true
	scrolling = false
	warning_animation_sprite.animation = 'warning_low'
	warning_animation_sprite.visible = true
