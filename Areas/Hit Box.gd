extends Area2D

export(int) var damage = 0
export(int) var knockback_force = 0
var knockback_direction: int = 0

func _on_Hit_Box_body_entered(body) -> void:
	if body.has_method("damage"):
		body.damage(damage, knockback_direction, knockback_force)
