extends CharacterBody2D

@export var speed: float = 100
@export var move_distance: float = 300
@export var vertical: bool = false  # true = moves up/down, false = left/right

var start_position: Vector2
var direction: int = 1

func _ready():
	start_position = global_position

func _physics_process(delta):
	# Set velocity based on direction
	if vertical:
		velocity.y = speed * direction
		velocity.x = 0
	else:
		velocity.x = speed * direction
		velocity.y = 0
	
	# Move platform
	move_and_slide()  # <-- no arguments in Godot 4
	
	# Reverse direction at boundaries
	if vertical:
		if global_position.y > start_position.y + move_distance:
			direction = -1
		elif global_position.y < start_position.y:
			direction = 1
	else:
		if global_position.x > start_position.x + move_distance:
			direction = -1
		elif global_position.x < start_position.x:
			direction = 1
