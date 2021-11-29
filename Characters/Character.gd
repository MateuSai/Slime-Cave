extends KinematicBody2D

export(float) var hearts = 1
var state: int = 0
var DEAD: int = 2

var is_stunned: bool = false
var velocity: Vector2 = Vector2.ZERO

onready var animationPlayer: AnimationPlayer = $AnimationPlayer
onready var flashAnimation: AnimationPlayer = $FlashAnimation

func damage(dam: int, direction: int, force: int) -> void:
	hearts -= dam * 0.5
	if name == "Player":
		emit_signal("life_changed", hearts)
	if hearts <= 0:
		state = DEAD
	
	knockback(direction, force)
	flash_effect()
	
func knockback(dir: int, force: int) -> void:
	velocity = Vector2.ZERO
	velocity += Vector2(dir, -0.9) * force
	stun()
	
func flash_effect() -> void:
	flashAnimation.play("flash")
	
func stun() -> void:
	is_stunned = true
	yield(get_tree().create_timer(0.2), "timeout")
	is_stunned = false

