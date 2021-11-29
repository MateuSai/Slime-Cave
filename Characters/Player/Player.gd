extends "res://Characters/Character.gd"

signal grounded_updated(is_grounded)
signal life_changed(player_hearts)

enum {
	IDLE,
	WALK,
}
var facing: String = "right"

var max_hearts: int = PlayerStats.max_hearts

const UP: Vector2 = Vector2(0, -1)
const SLOPE_STOP: int = 64
const FRICTION: float = 0.2
const WALL_FRICTION: float = 0.04
const AIR_FRICTION: float = 0.01

const speed: int = 5 * Globals.TILE_SIZE
var gravity_strength: float = 0
var gravity_direction: Vector2 = Vector2.DOWN

var max_jump_velocity: float = 0
var min_jump_velocity: float = 0
var max_jump_height: float = 2.1 * Globals.TILE_SIZE
var min_jump_height: float = 0.5 * Globals.TILE_SIZE
var jump_duration: float = 0.5
var is_jumping: bool = false
var is_grounded: bool = true

onready var animatedSprite: AnimatedSprite = $AnimatedSprite
onready var camera2D: Camera2D = $Camera2D
onready var rightWallRaycasts: Node2D = $WallRaycasts/RightWallRaycasts
onready var leftWallRaycasts: Node2D = $WallRaycasts/LeftWallRaycasts

func _ready() -> void:
	connect("grounded_updated", camera2D, "on_player_grounded_updated")
	connect("life_changed", get_parent().get_node("UI/HBoxContainer/Life"), "on_player_life_changed")
	hearts = max_hearts
	emit_signal("life_changed", max_hearts)
	
	gravity_strength = 2 * max_jump_height / pow(jump_duration, 2)
	max_jump_velocity = sqrt(2 * gravity_strength * max_jump_height)
	min_jump_velocity = sqrt(2 * gravity_strength * min_jump_height)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_up") and is_on_floor():
		velocity.y -= max_jump_velocity
		is_jumping = true
	elif event.is_action_pressed("ui_up") and is_on_wall():
		if check_wall_raycast(rightWallRaycasts):
			velocity += Vector2(-1, -0.8) * max_jump_velocity * 1.2
			facing = "left"
		else:
			velocity += Vector2(1, -0.8) * max_jump_velocity * 1.2
			facing = "right"
	if event.is_action_released("ui_up") and velocity.y < -min_jump_velocity:
		velocity.y = -min_jump_velocity
		
	if event.is_action_pressed("ui_atack"):
		launch_projectile()

func _physics_process(delta: float) -> void:
	var direction: int = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	
	update_gravity(direction)
	velocity += gravity_strength * gravity_direction * delta
	
	if is_jumping and velocity.y >= 0:
		is_jumping = false
		
	match state:
		IDLE:
			idle_state(direction)
		WALK:
			move_state(direction)
		DEAD:
			dead_state()
	
	velocity = move_and_slide(velocity, UP, SLOPE_STOP)
	if is_on_floor():
		velocity.x = lerp(velocity.x, 0, FRICTION)
	else:
		velocity.x = lerp(velocity.x, 0, AIR_FRICTION)
		
	if is_on_wall():
		velocity.y = lerp(velocity.y, 10, WALL_FRICTION)
	
	if is_grounded != is_on_floor():
		is_grounded = is_on_floor()
		emit_signal("grounded_updated", is_grounded)
	
func idle_state(direction: int) -> void:
	animationPlayer.play("idle " + facing)
			
	if direction != 0:
		state = WALK
	
func move_state(direction: int) -> void:
	if not is_stunned:
		velocity.x = direction * speed
	
	if direction > 0:
		facing = "right"
	elif direction < 0:
		facing = "left"
	else:
		state = IDLE
		
	animationPlayer.play("walk " + facing)
	
func dead_state() -> void:
	animatedSprite.hide()
	
func launch_projectile() -> void:
	var projectile: PackedScene = preload("res://Characters/Player/Slime Projectile.tscn")
	var Projectile: RigidBody2D = projectile.instance()
	get_parent().add_child(Projectile)
	if facing == "right":
		Projectile.throw(position, 1)
	elif facing == "left":
		Projectile.throw(position, -1)
	
func update_gravity(move_direction: int) -> void:
	if check_wall_raycast(rightWallRaycasts) and check_wall_raycast(leftWallRaycasts):
		if move_direction > 0:
			gravity_direction = Vector2.RIGHT
			animatedSprite.rotation = -PI/2
		elif move_direction < 0:
			gravity_direction = Vector2.LEFT
			animatedSprite.rotation = PI/2
	elif check_wall_raycast(rightWallRaycasts):
		gravity_direction = Vector2.RIGHT
		animatedSprite.rotation = -PI/2
	elif check_wall_raycast(leftWallRaycasts):
		gravity_direction = Vector2.LEFT
		animatedSprite.rotation = PI/2
	else:
		gravity_direction = Vector2.DOWN
		animatedSprite.rotation = 0
	
func check_wall_raycast(wall_raycast: Node2D) -> bool:
	for raycast in wall_raycast.get_children():
		if raycast.is_colliding():
			return true
	return false

