class_name PlayerCharacterStatsResource extends Resource

enum STATE { Initial = 0, Grounded, Airborne, Off, Reset }

@export var sprite_size := Vector2(128.0, 128.0) :
  set(v): if not sprite_size.is_equal_approx(v): sprite_size = v; recalculate()
@export var multiplier := 1.0 :
  set(v): if not is_equal_approx(multiplier, v): multiplier = v; recalculate()

@export var state := STATE.Initial :
  set(v): if state != v: state_prev = state; state = v
@export var state_prev := STATE.Initial

@export var g_accel := 32.0 * __util.v_only(sprite_size)
@export var jump_initial_vel := 4.0 * __util.v_only(sprite_size)
@export var max_vel_air := 16.0 * sprite_size * multiplier
@export var max_vel_ground := 8.0 * __util.h_only(sprite_size) * multiplier
@export var min_vel_loop := 6.0 * __util.h_only(sprite_size) * multiplier
@export var input_accel_ground := 16.0 * __util.h_only(sprite_size) * multiplier
@export var input_accel_air := 8.0 * __util.h_only(sprite_size) * multiplier
@export var frict_ground := 0.04 * __util.h_only(sprite_size)
@export var frict_air := 0.04 * __util.h_only(sprite_size)
@export var jump_peak := 0.05
@export var jump_time := jump_peak

func reset():
  state_prev = STATE.Reset
  state = STATE.Initial
  jump_time = jump_peak

func recalculate():
  max_vel_ground = 8.0 * __util.h_only(sprite_size) * multiplier
  input_accel_ground = 8.0 * __util.h_only(sprite_size) * multiplier
  input_accel_air = 4.0 * __util.h_only(sprite_size) * multiplier

