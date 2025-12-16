extends CharacterBody2D

# --- Movement settings ---
@export var speed: float = 200
@export var jump_velocity: float = -400
@export var gravity: float = 800

# --- Node references ---
var died_overlay: Sprite2D
var lose_button: BaseButton
var won_overlay: Sprite2D
var win_button: BaseButton

# --- State ---
var can_move := true
var is_dead := false
var has_won := false

# --- Recursive search for Godot 4 ---
func find_node_recursive(root: Node, name: String) -> Node:
	if root.name == name:
		return root
	for child in root.get_children():
		var found = find_node_recursive(child, name)
		if found:
			return found
	return null

# --- Hide overlays/buttons early ---
func _enter_tree():
	var root = get_tree().get_current_scene() # this is your "floor" node
	if not root:
		return

	died_overlay = find_node_recursive(root, "died") as Sprite2D
	if died_overlay:
		died_overlay.visible = false

	lose_button = find_node_recursive(root, "losebutton") as BaseButton
	if lose_button:
		lose_button.visible = false
		if not lose_button.is_connected("pressed", Callable(self, "_on_restart_pressed")):
			lose_button.pressed.connect(Callable(self, "_on_restart_pressed"))

	won_overlay = find_node_recursive(root, "won") as Sprite2D
	if won_overlay:
		won_overlay.visible = false

	win_button = find_node_recursive(root, "winbutton") as BaseButton
	if win_button:
		win_button.visible = false
		if not win_button.is_connected("pressed", Callable(self, "_on_restart_pressed")):
			win_button.pressed.connect(Callable(self, "_on_restart_pressed"))

# --- Ready ---
func _ready():
	print("Player ready. Overlays/buttons initialized.")

# --- Death ---
func die():
	if is_dead:
		return
	is_dead = true
	can_move = false

	if died_overlay:
		died_overlay.visible = true
	if lose_button:
		lose_button.visible = true

	velocity = Vector2.ZERO
	print("Player died!")

# --- Win ---
func win():
	if has_won:
		return
	has_won = true
	can_move = false

	if won_overlay:
		won_overlay.visible = true
	if win_button:
		win_button.visible = true

	velocity = Vector2.ZERO
	print("Player won!")

# --- Restart ---
func _on_restart_pressed():
	get_tree().reload_current_scene()

# --- Movement ---
func _physics_process(delta):
	if not can_move:
		return

	var moving_left := Input.is_action_pressed("move left")
	var moving_right := Input.is_action_pressed("move right")

	velocity.x = 0
	if moving_right:
		velocity.x += speed
	elif moving_left:
		velocity.x -= speed

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	if not is_on_floor():
		velocity.y += gravity * delta

	move_and_slide()

	var anim := $AnimatedSprite2D
	if not is_on_floor():
		if anim.animation != "jump":
			anim.play("jump")
	elif moving_left or moving_right:
		if anim.animation != "walk":
			anim.play("walk")
	else:
		if anim.animation != "idle":
			anim.play("idle")

	if moving_right:
		anim.flip_h = false
	elif moving_left:
		anim.flip_h = true
