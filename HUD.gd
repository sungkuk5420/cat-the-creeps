extends CanvasLayer

signal start_game

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	show_message("게임 오버")
	# Wait until the MessageTimer has counted down.
	yield($MessageTimer, "timeout")

	$Message.text = "고양이에게\n잡아먹혔습니다."
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	yield(get_tree().create_timer(1), "timeout")
	$StartButton.show()

func update_score(score):
	$ScoreLabel.text = str(score)

func _on_StartButton_pressed():
	print("click")
	$StartButton.hide()
	emit_signal("start_game")

func _on_MessageTimer_timeout():
	$Message.hide()
