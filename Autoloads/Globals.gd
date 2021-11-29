extends Node

const TILE_SIZE: int = 16
const GRAVITY: int = 100

func chance(num: int) -> bool:
	randomize()
	if randi() % 100 <= num:
		return true
	else:
		return false
		
func choose(choices):
	randomize()

	var rand_index: int = randi() % choices.size()
	return choices[rand_index]
