# Generally I like to put all physics/movement/health/damage/etc
# stats of a player in a resource (or multiple resources)
# This has a few benefits:
# - If you save the resource to a physical tres file and reference it,
#   every place that references it uses the same values,
#   it can be great for having a UI showing player stats
#   that doesn't need a direct reference to the player.
# - While prototyping you could create multiple versions of this resource
#   and swap them to check which "feels" better according to what you want
#   from your game.
# - Player got a power up? Just swap his stats resource
class_name PlayerCharacterStatsResource extends Resource

# Very light state machine for controlling the player
# generally you cannot rely on is_on_floor (is_on_wall, etc) alone
# because the logical state of your player might be different than the physics state
# I'm keeping it very simple for this demo,
# but I tend to prefer creating very extensive state machines
# to keep track of what's going on with the player
enum STATE { Initial = 0, Grounded, Airborne, Off, Reset }

@export var state := STATE.Initial :
  set(v): if state != v: state_prev = state; state = v
# Keeping track of the previous state can be very useful for troubleshooting
@export var state_prev := STATE.Initial

# All velocity/acceleration values here are defined as a function of the player size
# personally I find it easier to wrap my head around thinking of "player size" units than raw pixels
# raw pixels change meaning completely if you have a small vs big world,
# but if you stick to a base unit (generally player or tile size), everything follows from that
@export var sprite_size := Vector2(128.0, 128.0) :
  set(v): if not sprite_size.is_equal_approx(v): sprite_size = v; recalculate()

# This is here just to show a powerup that makes the player Gotta Go Fast!
# Having it be a multiplier because if the player is faster,
# a few other stats need to also be recalculated
@export var multiplier := 1.0 :
  set(v): if not is_equal_approx(multiplier, v): multiplier = v; recalculate()

@export var g_accel := 32.0 * __util.v_only(sprite_size)
@export var jump_initial_vel := 4.0 * __util.v_only(sprite_size)

# Maximum speeds can be defined independently if the player is on air or on ground
@export var max_vel_air := 16.0 * sprite_size * multiplier
@export var max_vel_ground := 8.0 * __util.h_only(sprite_size) * multiplier

# Controls how fast you have to be going to be able to complete a loop
# having this be a player stat could allow for a "sticky boots" powerup that just sets
# this value to zero for instance.
# Again here, expressing values as a function of other values can help make sense of your game
# writing it this way makes it obvious that you must be at 75% of your top speed to go around a loop
@export var min_vel_loop := 0.75 * max_vel_ground

# Friction/Acceleration
# - you don't stop on a dime when letting go of the direction
# - you take a few frames to get to top speed when starting to run
# - both acceleration and decceleration are different on ground/air
# - input_acceleration is applied every frame if you are holding a direction
# - friction_acceleration is applied every frame if you are NOT holding a direction
@export var input_accel_ground := 16.0 * __util.h_only(sprite_size) * multiplier
@export var input_accel_air := 8.0 * __util.h_only(sprite_size) * multiplier
@export var frict_ground := 0.04 * __util.h_only(sprite_size)
@export var frict_air := 0.04 * __util.h_only(sprite_size)

# I went with a very simple single size jump that applies acceleration up for some frames
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

