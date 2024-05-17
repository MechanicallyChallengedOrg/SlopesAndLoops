class_name PlayerCharacterInputNode extends Node

@export var h := 0.0
@export var v := 0.0
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
    "hv":hv,
    "jump_released":jump_released,
    "jump_held":jump_held,
    "jump_pressed":jump_pressed
  })

