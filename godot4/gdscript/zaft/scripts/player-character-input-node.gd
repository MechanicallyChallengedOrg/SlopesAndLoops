class_name PlayerCharacterInputNode extends Node

# input along the horizontal axis (relative to player)
# if the player is on the ground, h is the same as x
# if the player is upside down, h is the same as -x
# if the player is 90 deg sideways, it is the same as y or -y
@export var h := 0.0
# input along the vertical axis (relative to player)
# if the player is on the ground, h is the same as y
# if the player is upside down, h is the same as -y
# if the player is 90 deg sideways, it is the same as x or -x
@export var v := 0.0
# composite input horizontal and vertical (relative to player)
@export var hv := Vector2(h, v)
@export var jump_pressed := false
@export var jump_held := false
@export var jump_released := false

func _process(_delta: float) -> void:
  h = Input.get_axis('left', 'right')
  v = Input.get_axis('up', 'down')
  hv = Vector2(h, v).normalized()
  jump_pressed = Input.is_action_just_pressed('jump')
  jump_held = Input.is_action_pressed('jump')
  jump_released = Input.is_action_just_released('jump')

func _to_string() -> String:
  return var_to_str({
    "h":h,
    "v":v,
    "xy":hv,
    "jump_released":jump_released,
    "jump_held":jump_held,
    "jump_pressed":jump_pressed
  })

