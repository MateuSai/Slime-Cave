extends RigidBody2D

signal coin_collected()

var fade_time: float = 0.7

var is_collected: bool = false

onready var fadeTween: Tween = $FadeTween
onready var ui_coins: MarginContainer = get_parent().get_parent().get_node("UI/HBoxContainer/Coins")

func _ready() -> void:
	connect("coin_collected", ui_coins, "on_coin_collected")
	
	
func fade() -> void:
	fadeTween.interpolate_property(self, "scale", scale, scale * 1.5, fade_time, Tween.TRANS_SINE,
	 Tween.EASE_OUT)
	fadeTween.interpolate_property(self, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0),
	 fade_time, Tween.TRANS_SINE, Tween.EASE_OUT)
	fadeTween.start()
	
	
func _on_FadeTween_tween_completed(_object: Object, _key: NodePath) -> void:
	queue_free()
	
	
func _on_Coin_body_entered(_body: Node) -> void:
	if not is_collected:
		is_collected = true
		emit_signal("coin_collected")
		fade()
