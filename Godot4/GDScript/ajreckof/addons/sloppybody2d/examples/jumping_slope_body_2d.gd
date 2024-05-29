# tool is important to make sure the parent class is run in tool mode
@tool
extends SlopeBody2D

## The height the player can jump proportionate to [member SloppyBody2D.PLAYER_SIZE].
@export var JUMP_HEIGHT = 10

@onready var _JUMP_VELOCITY = PLAYER_SIZE * sqrt(2 * GRAVITY * JUMP_HEIGHT)


func _validate_velocity():
	if Input.is_action_just_pressed("ui_accept") and _is_on_floor:
		_velocity_up = _JUMP_VELOCITY
