extends CharacterBody2D

# --- Enemy settings ---
@export var speed: float = 100
@export var patrol_distance: float = 500

var start_position: Vector2
var direction: int = 1  # 1 = right, -1 = left
var anim: AnimatedSprite2D

func _ready():
	start_position = global_position
	anim = $AnimatedSprite2D
	anim.play("walk")
	
	# Connect Area2D signal
	$Area2D.body_entered.connect(_on_body_entered)

func _physics_process(delta):
	# --- Patrol movement ---
	velocity.x = speed * direction
	move_and_slide()

	# --- Flip sprite for left-facing default sprites ---
	anim.flip_h = direction > 0

	# --- Patrol boundaries ---
	if global_position.x > start_position.x + patrol_distance:
		direction = -1
	elif global_position.x < start_position.x:
		direction = 1

func _on_body_entered(body):
	print("Hit:", body.name)
	if body.is_in_group("Player"):
		body.die()
