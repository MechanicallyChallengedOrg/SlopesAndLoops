class_name PlayerCharacterStatsResource extends Resource

enum STATE { Initial = 0, Grounded, Airborne, Off }

func should_apply_gravity() -> bool:
  return state == STATE.Airborne

func axis_rel_h(_up:=up) -> Vector2:
  return _up.rotated(PI/2.0)

func axis_rel_v(_up:=up) -> Vector2:
  return _up.rotated(PI)

func vel_rel_h(_vel:=vel,_up:=up) -> Vector2:
  return _vel.project(axis_rel_h(_up))

func vel_rel_v(_vel:=vel,_up:=up) -> Vector2:
  return _vel.project(axis_rel_v(_up))

func up_angle(_up:=up) -> float:
  return rad_to_deg(_up.angle_to(Vector2.RIGHT))

@export var state := STATE.Initial :
  set(v):
    if state == v: return
    state_prev = state
    state = v
    print({ "state": STATE.find_key(state), "state_prev": STATE.find_key(state_prev) })
var state_prev := STATE.Initial

@export var pos := Vector2.ZERO :
  set(v):
    if pos.is_equal_approx(v): return
    pos_prev = pos
    pos = v
    # print({ "pos": pos, "pos_prev": pos_prev })
var pos_prev := Vector2.ZERO
@export var vel := Vector2.ZERO :
  set(v):
    if vel.is_equal_approx(v): return
    vel_prev = vel
    vel = v
    # print({ "vel": vel, "vel_prev": vel_prev })
var vel_prev := Vector2.ZERO
var up := Vector2.UP :
  set(v):
    if up.is_equal_approx(v): return
    up_prev = up
    up = v
    print({ "up": up, "up_prev": up_prev })
var up_prev := Vector2.UP
@export var g_accel := 8.0 * Vector2(0.0, 128.0)

@export var jump_initial_vel := 8.0 * Vector2(0.0, 128.0)
@export var max_vel_air := 8.0 * Vector2(128.0, 256.0)
@export var max_vel_ground := 8.0 * Vector2(128.0, 0.0)
@export var input_accel_ground := 4.0 * Vector2(128.0, 0.0)
@export var input_accel_air := 2.0 * Vector2(128.0, 0.0)
@export var frict_ground := Vector2(5.0, 0.0)
@export var frict_air := Vector2(5.0, 0.0)

func _to_string() -> String:
  return var_to_str({
    "pos":pos,
    "vel":vel,
    "|vel|":vel.length(),
    "vel_rel_h":vel_rel_h(),
    "vel_rel_v":vel_rel_v(),
    "axis_rel_h":axis_rel_h(),
    "axis_rel_v":axis_rel_v(),
    "should_apply_gravity":should_apply_gravity(),
    "pos_prev":pos_prev,
    "vel_prev":vel_prev,
    "|vel_prev|":vel_prev.length(),
    "up":up,
    "up_prev":up_prev,
    "up_angle":up_angle(),
    "max_vel_ground":max_vel_ground,
    "max_vel_air":max_vel_air,
    "input_accel_ground":input_accel_ground,
    "input_accel_air":input_accel_air,
    "frict_ground":frict_ground,
    "frict_air":frict_air,
    "g_accel":g_accel,
    "state":STATE.find_key(state),
    "state_prev":STATE.find_key(state_prev)
  })

