extends Area2D

func _ready():
	# Connect the body_entered signal
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	# Check if the colliding body is the player
	if body.is_in_group("Player"):
		body.die()
