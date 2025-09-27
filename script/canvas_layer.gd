extends CanvasLayer

var scoreText: Label 
var gameOverText: Label

var score: int = 0

func _ready() -> void:
	scoreText = $Score
	gameOverText = $GameOver
	gameOverText.hide()


func _on_enemy_dead() -> void:
	score += 1
	scoreText.text = "Score: " + str(score) 


func _on_player_dead() -> void:
	gameOverText.show()
