extends Node
var score = 0
var high_score = 0
var pipeArray = []
var pipeScene
var screen_width: float
var game_started = false

func _ready()-> void:
	pipeScene = preload("res://pipes.tscn")
	
	$Background/FirstTexture.start_moving()
	$Background/FirstTexture2.start_moving()
	load_highscore()
	print("high score: ", str(high_score))
	
func _on_pipes_area_exited():
	score += 1
	$HUD.show_score(score)
	
func _process(_delta)->void:
	if Input.is_action_pressed("ui_cancel"):
		game_started = false
		resetGame()
	if game_started and $PlayerCamera.zoom.x > 1.0:
			$PlayerCamera.zoom.x -= 7.5e-3
			$PlayerCamera.zoom.y -= 7.5e-3
			
func _on_pipe_timer_timeout():
	var newPipe = pipeScene.instantiate()
	newPipe.position.x = 800
	# random shift in y direction
	newPipe.position.y = (randi() % 350) - 100
	# add pipe to array (used to delete later on in case game gets cancelled)
	pipeArray.append(newPipe)
	# add pipe to current scene as a child
	add_child(newPipe)
	# set pipe "in motion"
	newPipe.start_moving()
	# connect the area detection of the player (needed for score counting)
	newPipe.area_exited.connect(_on_pipes_area_exited)


func start_game() -> void:
	screen_width = $Background.get_viewport_rect().size.x
	$HUD/StartButton.hide()
	for pipe in pipeArray:
		if is_instance_valid(pipe):
			pipe.position.x = 1600
			pipe.hide()
			pipe.queue_free()
	pipeArray = []
	score = 0
	$HUD.show_score(score)
	$HUD/scoreText.hide()
	$Player.position=Vector2(149, 212)
	$Player.is_dead = false
	game_started = true
	$HUD/GameTitle.hide()
	$HUD/GameStatusText.text = "3"
	$HUD/GameStatusText.show()
	await get_tree().create_timer(1.0).timeout
	$HUD/GameStatusText.text = "2"
	await get_tree().create_timer(1.0).timeout
	$HUD/GameStatusText.text = "1"
	await get_tree().create_timer(1.0).timeout
	$HUD/GameStatusText.text = "Dodge the pipes!"
	await get_tree().create_timer(0.5).timeout
	$Player.active = true


	$HUD/scoreText.show()
	$PipeTimer.start()
	$HUD/GameStatusText.hide()
	
func game_over():
	#$HUD/StartButton.show()
	#$HUD/GameTitle.show()
	$Background/FirstTexture.stop_moving()
	$Background/FirstTexture2.stop_moving()
	$Player.active = false
	$Player.is_dead = true
	#$pipes.stop_moving()
	for pipe in pipeArray:
		if is_instance_valid(pipe):
			pipe.stop_moving()
	$PipeTimer.stop()
	$HUD/GameStatusText.text = "Game over!"
	$HUD/GameStatusText.show()
	$HUD/MainMenuButton.show()
	game_started = false
	if high_score <= score:
		high_score = score
	store_highscore()


func resetGame() -> void:
	$Player.position=Vector2(210, 139)
	$Player.is_dead = false
	$Player.active = false
	$HUD/GameTitle.show()
	$HUD/GameStatusText.hide()
	$HUD/scoreText.hide()
	for pipe in pipeArray:
		if is_instance_valid(pipe):
			pipe.stop_moving()
			pipe.queue_free()
	store_highscore()
	score = 0
	$Player.current_t = 0.0
	$Player.velocity.y = 0.0
	$HUD/MainMenuButton.hide()
	$HUD/StartButton.show()
	$PlayerCamera.zoom = Vector2(1.8, 1.8)
	$Background/FirstTexture.start_moving()
	$Background/FirstTexture2.start_moving()
	
	
func quit_game()->void:
	#$Background.stop_moving()
	$HUD/StartButton.show()
	$HUD/GameTitle.show()
	$HUD/scoreText.hide()
	$Player.active = false
	#$pipes.stop_moving()
	for pipe in pipeArray:
		if is_instance_valid(pipe):
			pipe.hide()
			pipe.queue_free()
	$PipeTimer.stop()
	pipeArray = []
	game_started = false
	store_highscore()
	
	
func load_highscore()->void:
	if FileAccess.file_exists("user://scoreFile.txt"):
		var scoreFile = FileAccess.open("user://scoreFile.txt", FileAccess.READ)
		high_score = scoreFile.get_var()
		if high_score == null:
			high_score = 0
		else:
			high_score = high_score
	else:
		high_score = 0

func store_highscore()->void:
	var scoreFile = FileAccess.open("user://scoreFile.txt", FileAccess.WRITE)
	scoreFile.store_var(high_score)
	
