extends "res://Characters/Character.gd"

enum {
	HANGED,
	CHASE
}

const MAX_SPEED: int = 40
const ACCERELATION: int = 400
const FRICTION: float = 0.2

var player: KinematicBody2D = null
var direction_x: int = 0
var last_direction_x: int = 0

onready var hitBox: Area2D = $"Hit Box"
onready var coinContainer: Node2D = get_parent().get_parent().get_node("Coins")

func _ready() -> void:
	player = get_parent().get_parent().get_node("Player")
	

func _physics_process(delta: float) -> void:
	match state:
		HANGED:
			hanged_state()
		CHASE:
			chase_state(delta)
		DEAD:
			dead_state()
			
			
func hanged_state() -> void:
	animationPlayer.play("Hanged")
	
			
func chase_state(delta: float) -> void:
	var direction: Vector2 = player.position - position
	if direction.x < 0:
		animationPlayer.play("Fly Left")
		direction_x = -1
		if direction_x != last_direction_x:
			change_knockback_direction(direction_x)
			last_direction_x = direction_x
	elif direction.x > 0:
		animationPlayer.play("Fly Right")
		direction_x = 1
		if direction_x != last_direction_x:
			change_knockback_direction(direction_x)
			last_direction_x = direction_x
	
	if not is_stunned:
		velocity += direction.normalized() * ACCERELATION * delta
	
	velocity = move_and_slide(velocity.clamped(MAX_SPEED))
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	
func dead_state() -> void:
	randomize()
	spawn_coins(randi() % 8 + 3)
	queue_free()
	
	
func spawn_coins(amount: int) -> void:
	var coin: PackedScene = preload("res://Coin/Coin.tscn")
	for i in amount:
		var Coin: RigidBody2D = coin.instance()
		coinContainer.add_child(Coin)
		Coin.position = position
		Coin.apply_central_impulse(Vector2(rand_range(-30, 30), rand_range(-30, 10)))
	
	
func change_knockback_direction(dir: int) -> void:
	hitBox.knockback_direction = dir


func _on_PlayerDetector_body_entered(_body) -> void:
	state = CHASE
