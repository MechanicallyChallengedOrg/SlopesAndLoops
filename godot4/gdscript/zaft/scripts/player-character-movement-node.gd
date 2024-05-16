class_name PlayerCharacterMovementNode extends Node

@onready var player : PlayerCharacterScene = owner

func update_rays():
  if player.ray_center_down.is_colliding():
    player.ray_left_down.add_exception(player.ray_center_down.get_collider())
    player.ray_right_down.add_exception(player.ray_center_down.get_collider())
  else:
    player.ray_left_down.clear_exceptions()
    player.ray_right_down.clear_exceptions()

func _physics_process(delta: float) -> void:
  update_rays()
  player.stats.velocity = player.velocity
  if player.stats.state == player.stats.STATE.Initial: physics_process_initial(delta)
  elif player.stats.state == player.stats.STATE.Grounded: physics_process_grounded(delta)
  elif player.stats.state == player.stats.STATE.Airborne: physics_process_airborne(delta)
  else: printerr("player in unknown state!")
  player.stats.velocity = player.velocity

func physics_process_initial(_delta:float):
  if not player.ray_center_down.is_colliding():
    player.stats.state = player.stats.STATE.Airborne
  else:
    player.stats.state = player.stats.STATE.Grounded

func rotate_if_needed(colliding_ray:RayCast2D):
  var collision_normal := colliding_ray.get_collision_normal()
  if collision_normal != player.stats.up:
    player.stats.up = collision_normal
    player.rotate(player_rotation_from_prev())
    player.velocity = player.velocity.rotated(player_rotation_from_prev())

func snap_to_collision_point_if_needed(colliding_ray:RayCast2D):
  player.position = colliding_ray.get_collision_point() + (64.0 * player.stats.up)

func physics_process_grounded(delta:float):
  var colliding_ray := get_prioritized_ground_collision()
  if colliding_ray == null: return may_leave_floor()
  player.velocity = bound_velocity(player.velocity + accel_per_frame(delta))
  rotate_if_needed(colliding_ray)
  snap_to_collision_point_if_needed(colliding_ray)
  player.move_and_slide()
  may_leave_floor()

# collision with ground prioritizes the direction of player movement
func get_prioritized_ground_collision() -> RayCast2D:
  var moving_right : Array[RayCast2D] = [player.ray_right_down, player.ray_center_down, player.ray_left_down]
  var moving_left : Array[RayCast2D] = [player.ray_left_down, player.ray_center_down, player.ray_right_down]
  var moving_none : Array[RayCast2D] = [player.ray_center_down, player.ray_right_down, player.ray_left_down]
  var prio_rays : Array[RayCast2D]
  var vel_rel_h := player.stats.vel_rel_h()
  if vel_rel_h.is_zero_approx(): prio_rays = moving_none
  elif vel_rel_h.x < 0: prio_rays = moving_left
  else: prio_rays = moving_right
  for ray : RayCast2D in prio_rays: if ray.is_colliding(): return ray
  return null

func physics_process_airborne(delta:float):
  player.velocity = bound_velocity(player.velocity + accel_per_frame(delta))
  player.move_and_slide()
  may_snap_to_floor()

func player_rotation_from_prev() -> float:
  return player.stats.up_prev.angle_to(player.stats.up)

func player_rotation_from_up() -> float:
  return Vector2.UP.angle_to(player.stats.up)

func may_leave_floor():
  if false:
    player.stats.state = player.stats.STATE.Airborne

func may_snap_to_floor():
  if player.ray_center_down.is_colliding():
    player.stats.state = player.stats.STATE.Grounded

func bound_velocity(vel:Vector2) -> Vector2:
  if vel.length() > player.stats.max_vel_ground.length():
    return vel.normalized() * player.stats.max_vel_ground.x
  return vel

# real world xy acceleration (delta vel) per frame
func accel_per_frame(delta:float) -> Vector2:
  return (x_accel() * delta) + (y_accel() * delta)

# acceleration (delta vel) per frame alongside the player relative horizontal axis
func h_accel() -> Vector2:
  var result := Vector2.ZERO
  if is_zero_approx(player.input.h) and not is_zero_approx(player.velocity.length()):
    # result = Vector2(player.stats.frict_ground.x * sign(player.velocity) * -1.0)
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
  if not player.stats.should_apply_gravity(): result = Vector2.ZERO
  else: result = Vector2(0.0, player.stats.g_accel.y)
  return result

# acceleration (delta vel) per frame alongside the real world y axis
func y_accel() -> Vector2:
  return v_accel().rotated(player_rotation_from_up())
