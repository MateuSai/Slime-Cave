extends Area2D

const GRAVITY: int = 98

var is_player_under: bool = false
var exited_roof: bool = false
var exploted: bool = false

var damage: int = 2
var knockback_directions: Array = [-1, 1]
var knockback_force: int = 90

onready var animatedSprite: AnimatedSprite = $AnimatedSprite

func _physics_process(delta: float) -> void:
	if is_player_under and not exploted:
		fall(delta)


func fall(delta: float) -> void:
	position.y += GRAVITY * delta


func _on_PlayerDetector_body_entered(_body) -> void:
	is_player_under = true


func _on_Stalactite_body_entered(body) -> void:
	if exited_roof:
		exploted = true
		
		if body.is_in_group("player"):
			body.damage(damage, knockback_directions[randi() % knockback_directions.size()], knockback_force)
		
		animatedSprite.play("explode")
		yield(animatedSprite, "animation_finished")
		queue_free()


func _on_Stalactite_body_exited(_body) -> void:
	if not exited_roof:
		exited_roof = true
