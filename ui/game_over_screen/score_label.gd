extends Label


var final_score: int = 0
var current_displayed_score: float = 0.0
var tween: Tween

func _ready():
	# Inisialisasi tween
	tween = create_tween()
	tween.set_parallel(false)  # Pastikan animasi berurutan

func update_score(new_score: int):
	# Hentikan tween yang sedang berjalan
	if tween.is_running():
		tween.kill()
	
	# Hitung durasi berdasarkan selisih skor
	var score_diff = abs(new_score - current_displayed_score)
	var duration = clamp(score_diff * 0.002, 0.1, 1.0)  # Atur kecepatan di sini
	
	# Buat animasi baru
	tween = create_tween()
	tween.tween_method(
		_update_displayed_score,  # Method yang akan dipanggil
		current_displayed_score,  # Nilai awal
		new_score,                # Nilai akhir
		duration                  # Durasi animasi
	).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	
	final_score = new_score

func _update_displayed_score(value: float):
	current_displayed_score = value
	text = format_number(int(value))  # Format angka dengan separator

func format_number(number: int) -> String:
	# Fungsi untuk format angka dengan separator ribuan
	var string = str(number)
	var reversed = string.reverse()
	var formatted = PackedStringArray()
	for i in range(0, reversed.length(), 3):
		formatted.append(reversed.substr(i, 3))
	return formatted.join(",").reverse()
