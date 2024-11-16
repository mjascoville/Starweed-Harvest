extends Node2D

const STARWEED_SCENE = preload("res://starweed.tscn")  
const MAX_STARWEEDS = 5 
const SPARKLE_SCENE = preload("res://sparkle.tscn")
var starweeds = []  
var sparkle = null
var END_SCENE = preload("res://end.tscn")
var high_score = 0

func _ready():
	$SpawnTimer.connect("timeout", _on_SpawnTimer_timeout)
	$SpawnTimer.start() 
	$SparkleSpawn.connect("timeout", _on_SparkleTimer_timeout)
	$SparkleSpawn.start()
	$EndZone.connect("game_over", _on_game_over)
	
	var config = ConfigFile.new()
	var err = config.load("user://hscore.cfg")
	
	if err == OK:
		high_score = config.get_value("score", "highscore")

func _on_SparkleTimer_timeout():
	sparkle = SPARKLE_SCENE.instantiate()
	sparkle.position = Vector2(randf_range(8, 248), randf_range(8, 186))  
	add_child(sparkle)
	sparkle.connect("sparklecollect", _on_SparkleCollect)
	sparkle.get_node("Kill").connect("timeout", _on_SparkleKill)

func _on_SparkleKill():
	sparkle.queue_free()
	$SparkleSpawn.start()

func _on_SparkleCollect():
	$SparkleCollect.play()
	$TimerBar.position.x += 50
	$SparkleSpawn.start()
	sparkle.queue_free()

func spawn_starweed():
	if starweeds.size() < MAX_STARWEEDS:
		var starweed = STARWEED_SCENE.instantiate()
		starweed.position = Vector2(randf_range(8, 248), randf_range(8, 186))  
		starweeds.append(starweed)
		add_child(starweed)
		
		starweed.connect("collected", _on_starweed_collected)

func _on_SpawnTimer_timeout():
	spawn_starweed()
	if starweeds.size() < MAX_STARWEEDS:
		$SpawnTimer.start()

func _on_starweed_collected(starweed):
	var score_label = $ScoreCounter
	$collectsound.play()
	score_label.add_score(1)  
	starweeds.erase(starweed)  
	starweed.queue_free()  
	$SpawnTimer.start()

func _on_game_over():
	var end = END_SCENE.instantiate()
	var score = $ScoreCounter.score
	if score > high_score:
		high_score = score
		var config = ConfigFile.new()
		config.set_value("score", "highscore", high_score)
		config.save("user://hscore.cfg")

	end.get_node("Label").text = "Game Over\nScore: " + str(score) + "\n\nHigh Score: " + str(score)
	add_child(end)

	get_tree().paused = true  
