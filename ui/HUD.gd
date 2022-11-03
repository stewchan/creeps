extends CanvasLayer

export(PackedScene) var settings_scene

signal start_game

const HIGHSCORE_MAX_RESULTS = 5


func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()


func show_game_over(score):
	show_message("Game Over")
	update_score_label(score)
	yield($MessageTimer, "timeout")
	yield(SilentWolf.Scores.persist_score(Global.player_name, score), "sw_score_posted")
	yield(SilentWolf.Scores.get_high_scores(HIGHSCORE_MAX_RESULTS), "sw_scores_received")

	$ScoreLabel.hide()
	$Leaderboard.clear_leaderboard()
	$Leaderboard.render_board(SilentWolf.Scores.scores, [])
	$Leaderboard.show()
	yield(get_tree().create_timer(2), "timeout")
	# $SettingsButton.show()
	$StartButton.show()
	$NameLabel.show()


func update_score_label(score):
	$ScoreLabel.text = str(score)


func _on_StartButton_pressed():
	$NameLabel.hide()
	$StartButton.hide()
	# $SettingsButton.hide()
	$Leaderboard.hide()
	$ScoreLabel.show()
	emit_signal("start_game")


func _on_MessageTimer_timeout():
	$MessageLabel.hide()


# func _on_SettingsButton_pressed():
# 	# warning-ignore:return_value_discarded
# 	get_tree().change_scene_to(settings_scene)


func _on_NameLabelButton_pressed():
	if OS.has_feature("JavaScript"):
		var name = JavaScript.eval(
			"""
			prompt("Player Name:", name)
		"""
		)
		name = name.substr(0, 10)
		$NameLabel.text = name
		Global.save_name(name)
