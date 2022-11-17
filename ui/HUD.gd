extends CanvasLayer

export(PackedScene) var settings_scene

signal start_game

const HIGHSCORE_MAX_RESULTS = 10
const MAX_NAME_LENGTH = 12


onready var message_label = $MessageLabel
onready var leaderboard = $Leaderboard
onready var tween_out = $TweenOut
onready var tween_in = $TweenIn


func _ready():
	$NameLabel.text = Global.player_name
	leaderboard.render_board(SilentWolf.Scores.scores, [])
	
	tween_out.connect("tween_all_completed", self, "tween_out_completed")
	tween_in.connect("tween_all_completed", self, "tween_in_completed")
	
	yield(get_tree().create_timer(2),"timeout")
	
	
	tween_in.start()

# Show message with a delay
func show_message(text):
	message_label.text = text
	message_label.show()
	$MessageTimer.start()


func show_game_over(score):
	show_message("Game Over")
	update_score_label(score)
	yield($MessageTimer, "timeout")
	yield(SilentWolf.Scores.persist_score(Global.player_name, score), "sw_score_posted")
	yield(SilentWolf.Scores.get_high_scores(HIGHSCORE_MAX_RESULTS), "sw_scores_received")

	$ScoreLabel.hide()
	leaderboard.clear_leaderboard()
	leaderboard.render_board(SilentWolf.Scores.scores, [])
	leaderboard.show()
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
	leaderboard.hide()
	$ScoreLabel.show()
	emit_signal("start_game")


func _on_MessageTimer_timeout():
	message_label.hide()


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
		var check = name.to_lower().strip_edges()
		if check == "wipeleaderboard":
			SilentWolf.Scores.wipe_leaderboard()
		else:
			name = name.substr(0, MAX_NAME_LENGTH)
			$NameLabel.text = name
			Global.save_name(name)


	
func tween_out_completed():
	tween_in.interpolate_property(message_label, "modulate:a", 0, 1, 1.5)
	tween_in.interpolate_property(leaderboard, "modulate:a", 1, 0, 1.5)
	yield(get_tree().create_timer(5),"timeout")
	tween_in.start()


func tween_in_completed():
	tween_out.interpolate_property(message_label, "modulate:a", 1, 0, 1.5)
	tween_out.interpolate_property(leaderboard, "modulate:a", 0, 1, 1.5)
	yield(get_tree().create_timer(5),"timeout")
	tween_out.start()
	
