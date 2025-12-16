extends Node2D  # Use Node2D, no need for CharacterBody2D if stationary

# --- Nodes ---
@onready var anim = $AnimatedSprite2D
@onready var head_area = $Area2D

# --- Attack settings ---
@export var attack_animation: String = "walk"  # your snake attack animation
@export var attack_interval: float = 2.0       # seconds between attacks

var attack_timer := 0.0
var attacking := false

func _ready():
	# Connect Area2D signal
	head_area.body_entered.connect(_on_head_hit)
	# Hide the head initially
	head_area.visible = false

func _process(delta):
	# Timer for periodic attacks
	attack_timer += delta

	if not attacking and attack_timer >= attack_interval:
		start_attack()
	
	# Check if the animation finished
	if attacking and not anim.is_playing():
		end_attack()

func start_attack():
	attacking = true
	attack_timer = 0.0
	head_area.visible = true
	
	if anim.sprite_frames.has_animation(attack_animation):
		anim.animation = attack_animation
		anim.play()

func end_attack():
	attacking = false
	head_area.visible = false
	# snake retracts automatically, ready for next attack

func _on_head_hit(body):
	if body.is_in_group("Player"):
		body.die()
