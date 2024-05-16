class_name PlayerCharacterStatsResource extends Resource

enum PLAYER_STATES { INITIAL = 0, GROUND, AIR }

var current_state := PLAYER_STATES.INITIAL
var velocity := Vector2.ZERO
var velocity_prev := Vector2.ZERO
var up := Vector2.UP
var up_prev := Vector2.UP
var facing := Vector2.RIGHT
var attached := false
var input_accel_ground := 4.0 * Vector2(128.0, 128.0)
var input_accel_air := Vector2(10.0, 10.0)
var frict_ground := Vector2(50.0, 50.0)
var frict_air := Vector2(5.0, 5.0)
var max_vel_air := Vector2(10.0, 10.0)
var max_vel_ground := 8.0 * Vector2(128.0, 128.0)
var g_accel := Vector2(0.0, 128.0)

func _to_string() -> String:
  return var_to_str({
    "velocity":velocity,
    "velocity_prev":velocity_prev,
    "up":up,
    "up_prev":up_prev,
    "facing":facing,
    "attached":attached,
    "max_vel_ground":max_vel_ground,
    "max_vel_air":max_vel_air,
    "input_accel_ground":input_accel_ground,
    "input_accel_air":input_accel_air,
    "frict_ground":frict_ground,
    "frict_air":frict_air,
    "g_accel":g_accel,
    "state":PLAYER_STATES.find_key(current_state)
  })

