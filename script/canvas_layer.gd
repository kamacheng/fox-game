extends CanvasLayer


@onready var scoreText: Label = $Control/Score
@onready var gameOverText: Label = $Control/GameOver
@onready var pause_panel: Panel = $Control/PausePanel
@onready var difficulty_label: Label = $Control/Difficulty_increased
@onready var ui_sfx: AudioStreamPlayer = $UISfx


var score_point: int = 0
var bgm_player: AudioStreamPlayer2D
var pause_time: float

signal difficulty_increased

func _ready() -> void:
	bgm_player = get_node("/root/Bgm")
	gameOverText.hide()
	pause_panel.hide()
	
	var spawn = get_node("/root/Game/Spawn")
	if spawn != null:
		difficulty_increased.connect(spawn.increase_difficulty)


func _process(delta: float) -> void:
	var volume_linear = db_to_linear(bgm_player.volume_db)
	var target_lolum = 0.0 if get_tree().paused else 1.0
	volume_linear = lerp(volume_linear, target_lolum , delta * 15)
	bgm_player.volume_db = linear_to_db(volume_linear)
	bgm_player.stream_paused = get_tree().paused and Time.get_ticks_msec() > pause_time + 300


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_ESCAPE and event.pressed:
			if not get_tree().paused:
				pause()
			else:
				unpause()


func _get_score(score: int = 1) -> void:
	score_point += score
	scoreText.text = "Score: " + str(score_point) 


func _on_player_dead() -> void:
	gameOverText.show()


# 暂停继续和退出
func pause():
	ui_sfx.play()
	get_tree().paused = true
	pause_panel.visible = true
	pause_time = Time.get_ticks_msec()


func unpause():
	ui_sfx.play()
	get_tree().paused = false
	pause_panel.visible = false


func quit_game():
	ui_sfx.play()
	get_tree().quit()
