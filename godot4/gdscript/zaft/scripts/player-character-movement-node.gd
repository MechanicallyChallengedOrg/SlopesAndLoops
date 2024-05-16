class_name PlayerCharacterMovementNode extends Node

@onready var player : PlayerCharacterScene = owner

func _physics_process(delta: float) -> void:
  player.stats.velocity = player.velocity
  player.velocity = bound_velocity(player.velocity + vel_delta_per_frame(delta))
  player.move_and_slide()
  snap_to_floor()
  player.stats.velocity = player.velocity
  player.stats.velocity_prev = player.stats.velocity

func player_rotation_from_prev() -> float: return player.stats.up_prev.angle_to(player.stats.up)
func player_rotation_from_up() -> float: return Vector2.UP.angle_to(player.stats.up)

func snap_to_floor():
  if player.ray_center_down.is_colliding():
    player.stats.up_prev = player.stats.up
    player.stats.up = player.ray_center_down.get_collision_normal()
    player.rotate(player_rotation_from_prev())
    print(player.velocity)
    player.velocity = player.velocity.rotated(player_rotation_from_prev())
    print(player.velocity)
    player.position = player.ray_center_down.get_collision_point() + (64.0 * player.stats.up)
    player.stats.attached = true

func bound_velocity(vel:Vector2) -> Vector2:
  return vel.clamp(-player.stats.max_vel_ground, player.stats.max_vel_ground)

func vel_delta_per_frame(delta:float) -> Vector2:
  return (x_accel() * delta) + (y_accel() * delta)

# acceleration (delta vel) per frame alongside the player relative horizontal axis
func h_accel() -> Vector2:
  var result := Vector2.ZERO
  if is_zero_approx(player.input.h) and not is_zero_approx(player.velocity.x):
    # result = Vector2(player.stats.frict_ground.x * sign(player.velocity.x) * -1.0, 0.0)
    pass
  else:
    result = Vector2(player.input.h * player.stats.input_accel_ground.x, 0.0)
  return result

# acceleration (delta vel) per frame alongside the real world x axis
func x_accel() -> Vector2:
  return h_accel().rotated(player_rotation_from_up())

# acceleration (delta vel) per frame alongside the player relative vertical axis
func v_accel() -> Vector2:
  var result := Vector2.ZERO
  if player.stats.attached: result = Vector2.ZERO
  else: result = Vector2(0.0, player.stats.g_accel.y)
  return result

# acceleration (delta vel) per frame alongside the real world y axis
func y_accel() -> Vector2:
  return v_accel().rotated(player_rotation_from_up())
