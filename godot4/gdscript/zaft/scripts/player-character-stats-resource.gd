class_name PlayerCharacterStatsResource extends Resource

enum STATE {
  Initial = 0,  # unknown, player just spawned
  Grounded,     # attached to ground - gravity does NOT apply
  Airborne      # falling/jumping - gravity applies
}

func should_apply_gravity() -> bool:
  return state == STATE.Airborne

func axis_rel_h() -> Vector2:
  return up.rotated(-PI/2.0)

func axis_rel_v() -> Vector2:
  return up.rotated(PI)

func vel_rel_h() -> Vector2:
  return velocity.project(axis_rel_h())

func vel_rel_v() -> Vector2:
  return velocity.project(axis_rel_v())

func up_angle() -> float:
  return rad_to_deg(Vector2.RIGHT.angle_to(up))

var state := STATE.Initial :
  set(v):
    if state == v: return
    state_prev = state
    state = v
var state_prev := STATE.Initial

# real world
var velocity := Vector2.ZERO :
  set(v):
    if velocity == v: return
    velocity_prev = velocity
    velocity = v
var velocity_prev := Vector2.ZERO
var up := Vector2.UP :
  set(v):
    if up == v: return
    up_prev = up
    up = v
var up_prev := Vector2.UP
var facing_prev := Vector2.RIGHT
var g_accel := Vector2(0.0, 128.0)

# relative to player
var max_vel_air := Vector2(10.0, 10.0)
var max_vel_ground := 8.0 * Vector2(128.0, 128.0)
var input_accel_ground := 4.0 * Vector2(128.0, 128.0)
var input_accel_air := Vector2(10.0, 10.0)
var frict_ground := Vector2(50.0, 50.0)
var frict_air := Vector2(5.0, 5.0)

func _to_string() -> String:
  return var_to_str({
    "velocity":velocity,
    "vel_rel_h":vel_rel_h(),
    "vel_rel_v":vel_rel_v(),
    "axis_rel_h":axis_rel_h(),
    "axis_rel_v":axis_rel_v(),
    "should_apply_gravity":should_apply_gravity(),
    "velocity_prev":velocity_prev,
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

