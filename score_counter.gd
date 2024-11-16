extends Label

var score = 0

func add_score(points: int = 1):
	score += points
	update_score_display()

func update_score_display():
	text = "" + str(score)
