extends AnimatedSprite2D

# minimal dan maximal interval sebelum muncul glitch (detik)
const GLITCH_MIN = 0.5
const GLITCH_MAX = 2.0
# durasi tampilnya frame glitch (detik)
const GLITCH_DURATION = 0.2

var glitch_timer = 0.0
var next_glitch_in = 0.0

func _ready():
	# kita manual set animation ke idle tapi paused
	animation = "idle"
	stop()
	_reset_timer()

func _process(delta):
	glitch_timer -= delta
	if glitch_timer <= 0:
		# tampilkan frame glitch
		frame = 1
		# setelah GLITCH_DURATION kembali ke normal
		await get_tree().create_timer(GLITCH_DURATION).timeout
		frame = 0
		_reset_timer()

func _reset_timer():
	# random interval sebelum glitch berikutnya
	next_glitch_in = randf_range(GLITCH_MIN, GLITCH_MAX)
	glitch_timer = next_glitch_in
