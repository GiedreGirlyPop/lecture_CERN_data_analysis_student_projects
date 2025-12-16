extends Area2D

func _ready():
	# Connect the signal for when the player touches the trophy
	self.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	print("won:", body.name)
	if body.is_in_group("Player"):
		body.win()
