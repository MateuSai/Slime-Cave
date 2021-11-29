extends MarginContainer

onready var label: Label = $NinePatchRect/Label

func _ready() -> void:
	label.text = str(PlayerStats.coins)
	

func on_coin_collected() -> void:
	PlayerStats.coins += 1
	label.text = str(PlayerStats.coins)

