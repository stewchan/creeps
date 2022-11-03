extends Node

var player_name


# Save the player's name to local storage
func save_name(name):
	player_name = name
	var config = ConfigFile.new()
	config.set_value("player", "name", name)
	config.save("user://settings.cfg")


func _ready():
	randomize()

	# Load SilentWolf settings from env
	var api_key
	var game_id

	var env_config = ConfigFile.new()
	var env_err = env_config.load("res://.env")
	if env_err == OK:
		api_key = env_config.get_value("silentwolf", "api_key")
		game_id = env_config.get_value("silentwolf", "game_id")

	# Load player name from file
	var player_config = ConfigFile.new()
	var player_err = player_config.load("user://settings.cfg")
	if player_err == OK:
		player_name = player_config.get_value("player", "name")
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
