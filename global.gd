extends Node

var player_name


func save_name(name):
	var config = ConfigFile.new()
	config.set_value("player", "name", name)
	config.save("user://settings.cfg")


func _ready():
	randomize()

	# Load SilentWolf settings from env
	var api_key
	var game_id
	var f = File.new()
	f.open("res://.env", File.READ)
	api_key = str(f.get_line())
	game_id = str(f.get_line())
	f.close()

	# Load player name from file
	var config = ConfigFile.new()
	var err = config.load("user://settings.cfg")
	if err == OK:
		player_name = config.get_value("player", "name")
	else:
		player_name = "Player" + str(randi() % 1000).pad_zeros(2)

	SilentWolf.configure(
		{
			"api_key": str(api_key),
			"game_id": str(game_id),
			"game_version": "1.0.1",
			"log_level": 1,
		}
	)

	SilentWolf.configure_scores(
		{
			"open_scene_on_close": "res://Main.tscn",
		}
	)
