extends RigidBody2D

var throw_force: int = 150
var direction: int = 0

onready var hitBox: Area2D = $"Hit Box"

func throw(launch_position: Vector2, player_direction: int) -> void:
	position = launch_position
	direction = player_direction
	apply_central_impulse(Vector2(direction, -0.1) * throw_force)
	hitBox.knockback_direction = direction
