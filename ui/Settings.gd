extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	$PlayerName.text = Global.player_name


func _on_SaveButton_pressed():
	save_name()


func _on_PlayerName_text_entered(_new_text: String):
	save_name()


func _on_CancelButton_pressed():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Main.tscn")


func save_name():
	# Save the name
	Global.save_name($PlayerName.text)
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Main.tscn")


func _on_PlayerName_focus_entered():
	$PlayerName.text = ""


func _on_TextureButton_pressed():
	print("lineedit pressed")
	#if OS.has_feature("Javascript"):
	name = $PlayerName.text
	find_node("PlayerName").text = JavaScript.eval(
		"""
		prompt("Player Name:", name)
	"""
	)
