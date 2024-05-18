class_name PlayerCharacterStateGroundedNode extends Node

@onready var player : PlayerCharacterScene = owner

func _physics_process(delta: float) -> void:
  if player.stats.state != player.stats.STATE.Grounded: return
  physics_process_grounded(delta)
  player.move_and_slide()
  process_after_physics_update(delta)

func initiate_jump():
  player.velocity += player.stats.jump_initial_vel.y * player.up_direction
  player.stats.jump_time = 0.0
  player.move_and_slide()

func transition_to_airborne():
  if player.ray_left_down.is_colliding() or\
    player.ray_right_down.is_colliding() or\
    player.ray_center_down.is_colliding():
    player.apply_floor_snap()
    return
  player.stats.state = player.stats.STATE.Airborne

func current_ground_normal() -> Vector2:
  var collision := player.get_last_slide_collision()
  var normal := collision.get_normal() if collision else player.get_floor_normal()
  return normal.snapped(Vector2(0.01, 0.01))

func rotation_delta_relative_to_player_rotation() -> float:
  var normal := current_ground_normal()
  var angle := Vector2.UP.angle_to(normal)
  var rotation_delta := angle - player.rotation
  return rotation_delta

func snap_to_floor_angle_if_needed():
  var normal := current_ground_normal()
  var rotation_delta_in_rads := rotation_delta_relative_to_player_rotation()
  var rotation_delta_in_degrees = roundi(rad_to_deg(rotation_delta_in_rads))
  if abs(rotation_delta_in_degrees) >= 10:
    var rotation_delta_in_degrees_snapped_to_5 = snappedi(rotation_delta_in_degrees, 5)
    var snapped_rotation_delta_in_rads := deg_to_rad(rotation_delta_in_degrees_snapped_to_5)
    player.up_direction = normal
    player.rotate(snapped_rotation_delta_in_rads)

func process_after_physics_update(_delta:float):
  if player.stats.state != player.stats.STATE.Grounded: return
  if player.input.jump_pressed:
    initiate_jump()
  if not player.is_on_floor():
    return transition_to_airborne()
  snap_to_floor_angle_if_needed()

func velocity_relative_to_absolute_axis() -> Vector2:
  var rel_vel := player.velocity.rotated(-player.rotation)
  return rel_vel

func physics_process_grounded(delta:float):
  var rel_vel := velocity_relative_to_absolute_axis()
  rel_vel += accel_gravity(delta)
  rel_vel += accel_input(delta)
  rel_vel -= accel_frict(rel_vel,delta)
  rel_vel = rel_vel.clamp(-player.stats.max_vel_ground, player.stats.max_vel_ground)
  player.velocity = rel_vel.rotated(player.rotation)

func accel_frict(rel_vel:Vector2,delta:float) -> Vector2:
  if not is_zero_approx(player.input.h) or rel_vel.is_zero_approx(): return Vector2.ZERO
  return Vector2.RIGHT * rel_vel.x * player.stats.frict_ground.x * delta

func accel_input(delta:float) -> Vector2:
  return Vector2.RIGHT * player.input.h * player.stats.input_accel_ground.x * delta

func accel_gravity(_delta:float) -> Vector2:
  return player.stats.g_accel * _delta
