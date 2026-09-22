extends Node

@export var mob_scene: PackedScene
@export var powerup_scene: PackedScene
var score
var best_score = 0

# called when the node enters the scene tree for the first time
func _ready() -> void:
	best_score = load_best_score()
	$HUD.update_best(best_score)

func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	$PowerupTimer.stop()
	$Music.stop()
	$DeathSound.play()

	var new_record = score > best_score
	if new_record:
		best_score = score
		save_best_score(best_score)
		$HUD.update_best(best_score)
	$HUD.show_game_over(new_record)

func new_game():
	# delete mobs and powerups from the last round
	get_tree().call_group("mobs", "queue_free")
	get_tree().call_group("powerups", "queue_free")
	score = 0
	$SlowTimer.stop()
	$MobTimer.wait_time = 0.5
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get ready if you wanna become the GOAT")
	$Music.play()

func _on_hud_start_game() -> void:
	new_game()

func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()
	$PowerupTimer.start()

func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)
	# spawn mosquitos faster over time
	if $MobTimer.wait_time > 0.15:
		$MobTimer.wait_time -= 0.008

func _on_mob_timer_timeout() -> void:
	var mob = mob_scene.instantiate()

	# choose a random position for a mob from a defined path
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	# set mob's position to random
	mob.position = mob_spawn_location.position

	# perpendicular direction to the path
	var direction = mob_spawn_location.rotation + PI /2

	# randomness to direction, so it feels lkke enemies are appealing randomly
	direction += randf_range(-PI/4,PI/4)
	mob.rotation = direction

	# random velocity
	var velocity = Vector2(randf_range(150.0,250.0),0.0)
	mob.base_velocity = velocity.rotated(direction)
	mob.linear_velocity = mob.base_velocity
	if not $SlowTimer.is_stopped():
		mob.linear_velocity = mob.base_velocity * 0.35

	# spanw the mob by adding it to the main sceen
	add_child(mob)

func _on_powerup_timer_timeout() -> void:
	var powerup = powerup_scene.instantiate()
	powerup.kind = ["shield", "slow", "shrink", "heart"].pick_random()
	powerup.position = Vector2(randf_range(80, 1000), randf_range(80, 640))
	add_child(powerup)

func _on_player_powerup_picked(kind) -> void:
	if kind == "shield":
		$HUD.show_message("Shield!")
	if kind == "slow":
		$HUD.show_message("Mosquitos slowed!")
		$SlowTimer.start()
		for mob in get_tree().get_nodes_in_group("mobs"):
			mob.linear_velocity = mob.base_velocity * 0.35
	if kind == "shrink":
		$HUD.show_message("Tiny goat!")
	if kind == "heart":
		$HUD.show_message("+1 health")

func _on_slow_timer_timeout() -> void:
	for mob in get_tree().get_nodes_in_group("mobs"):
		mob.linear_velocity = mob.base_velocity

# save file stays after closing the game
func load_best_score():
	var config = ConfigFile.new()
	if config.load("user://goat_save.cfg") != OK:
		return 0
	return config.get_value("scores", "best", 0)

func save_best_score(value):
	var config = ConfigFile.new()
	config.set_value("scores", "best", value)
	# user folder lives in AppData in Godot folder, so it persists if the game folder is deleted
	# it lives under this path: 
	# C:\Users\<user>\AppData\Roaming\Godot\app_userdata\Be The GOAT\goat_save.cfg
	config.save("user://goat_save.cfg")
