extends Camera2D

const LOOK_AHEAD_FACTOR: float = 0.2
const SHIFT_TRANS: int = Tween.TRANS_SINE
const SHIFT_EASE: int = Tween.EASE_OUT
const SHIFT_DURATION: float = 1.0

var facing: float = 0

onready var prev_camera_position: Vector2 = get_camera_position()
onready var shiftTween: Tween = $ShiftTween

func _process(_delta: float) -> void:
	prev_camera_position = get_camera_position()
	
func check_facing() -> void:
	var new_facing: float = sign(get_camera_position().x - prev_camera_position.x)
	if new_facing != 0 and facing != new_facing:
		facing = new_facing
		var target_offset: float = get_viewport_rect().size.x * LOOK_AHEAD_FACTOR * facing
		
		shiftTween.interpolate_property(self, "position:x", position.x, target_offset,
		 SHIFT_DURATION, SHIFT_TRANS, SHIFT_EASE)
		shiftTween.start()

func on_player_grounded_updated(is_grounded) -> void:
	drag_margin_v_enabled = !is_grounded

