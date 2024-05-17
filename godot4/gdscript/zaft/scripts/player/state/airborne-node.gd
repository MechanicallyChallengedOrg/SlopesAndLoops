class_name PlayerCharacterStateAirborneNode extends Node

@onready var player : PlayerCharacterScene = owner

func _physics_process(delta: float) -> void:
  if player.stats.state != player.stats.STATE.Airborne: return
  if player.stats.jump_time <= player.stats.jump_peak:
    player.stats.jump_time += delta
  physics_process_airborne(delta)
  player.move_and_slide()
  process_after_physics_update(delta)

func process_after_physics_update(_delta:float):
  if player.stats.state != player.stats.STATE.Airborne: return
  if player.is_on_floor(): player.stats.state = player.stats.STATE.Grounded

func physics_process_airborne(delta:float):
  var rel_vel := player.velocity.rotated(-player.rotation)
  rel_vel += accel_gravity(delta)
  rel_vel += accel_input(delta)
  rel_vel -= accel_frict(rel_vel,delta)
  rel_vel = rel_vel.clamp(-player.stats.max_vel_air, player.stats.max_vel_air)
  player.velocity = rel_vel.rotated(player.rotation)

  var angle := player.up_direction.angle_to(Vector2.UP)
  if not is_zero_approx(angle):
    player.up_direction = player.up_direction.rotated(angle)
    player.rotate(angle)

func accel_frict(rel_vel:Vector2,delta:float) -> Vector2:
  if not is_zero_approx(player.input.h) or rel_vel.is_zero_approx(): return Vector2.ZERO
  return Vector2.RIGHT * rel_vel.x * player.stats.frict_air.x * delta

func accel_input(delta:float) -> Vector2:
  return Vector2.RIGHT * player.input.h * player.stats.input_accel_air.x * delta

func accel_gravity(_delta:float) -> Vector2:
  if player.stats.jump_time <= player.stats.jump_peak:
    var remainder := player.stats.jump_time / player.stats.jump_peak
    return player.stats.jump_initial_vel.y * remainder * player.up_direction
  return player.stats.g_accel * _delta
