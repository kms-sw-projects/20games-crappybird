extends Node2D

signal startGame
signal resetGame

func show_score(score_pass):
	$scoreText.text = "Score: " + str(score_pass)
	$scoreText.show()

func _on_start_button_pressed():
	startGame.emit()

func _on_main_menu_button_pressed():
	resetGame.emit()
