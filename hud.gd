extends CanvasLayer
signal start_game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over(new_record):
	if new_record:
		show_message("New record!")
	else:
		show_message("The mosquitos got you!")
	await $MessageTimer.timeout

	$Message.text = "Be The GOAT"
	$Message.show()
	# wait for aone-shot timer to finish
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()

func update_score(score):
	$ScoreLabel.text = str(score)

func update_health(health):
	$HealthLabel.text = "Health: " + str(health)
	$HealthLabel.show()

func update_best(best):
	$BestLabel.text = "Best: " + str(best)

func _on_start_button_pressed():
	$StartButton.hide()
	start_game.emit()

func _on_message_timer_timeout():
	$Message.hide()
