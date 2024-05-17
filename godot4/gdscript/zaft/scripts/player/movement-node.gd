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
  if player.stats.state == player.stats.STATE.Initial: physics_process_initial(delta)
  elif player.stats.state == player.stats.STATE.Grounded: physics_process_grounded(delta)
  elif player.stats.state == player.stats.STATE.Airborne: physics_process_airborne(delta)
  elif player.stats.state == player.stats.STATE.Off:
    pass
  else: printerr("player in unknown state!")

func physics_process_initial(_delta:float):
  if not player.ray_center_down.is_colliding():
    player.stats.state = player.stats.STATE.Airborne
  else:
    player.stats.state = player.stats.STATE.Grounded

func rotate_if_needed(colliding_ray:RayCast2D):
  var normal := colliding_ray.get_collision_normal()
  if not normal.is_equal_approx(player.stats.up):
    var rotation := player.stats.up.angle_to(normal)
    print("rotate", {
      "angle": rad_to_deg(rotation),
      "normal": normal,
      "up": player.stats.up
    })
    player.stats.up = normal
    player.rotate(rotation)
    player.set_vel(player.velocity.rotated(rotation))

func rotate_if_needed_up(up:=Vector2.UP):
  if not up.is_equal_approx(player.stats.up):
    var rotation := player.stats.up.angle_to(up)
    player.stats.up = up
    player.rotate(rotation)
    player.set_vel(player.velocity.rotated(rotation))

const half_player := 64.0
func snap_to_collision_point_if_needed(ray:RayCast2D,_depth:=0):
  if not ray.is_colliding():
    if player.ray_center_down_ext.is_colliding():
      return snap_to_collision_point_if_needed(player.ray_center_down_ext)
    else: return
  var normal := ray.get_collision_normal()
  var point := ray.get_collision_point()
  var projected := player.velocity.project(normal)
  if not projected.is_zero_approx():
    print("snap", {
      "n": normal,
      "point": point,
      "player": player.position,
      "v": player.velocity,
      "projv": projected,
      "projv*n": player.velocity.project(normal) * normal
    })
  rotate_if_needed(ray)
  player.set_vel(player.velocity + projected * normal)
  if ray == player.ray_center_down_ext:
    player.set_pos(point + (half_player * normal) - (8.0 * normal))
  else:
    player.set_pos(point + (half_player * normal))

func physics_process_grounded(delta:float):
  var colliding_ray := get_prioritized_ground_collision()
  if colliding_ray == null: return may_leave_floor(delta)
  player.set_vel(bound_velocity(player.velocity, accel_per_frame(delta), frict_per_frame(delta)))
  snap_to_collision_point_if_needed(colliding_ray)
  apply_velocity(delta)
  may_leave_floor(delta)

func physics_process_airborne(delta:float):
  disable_casts(player.ray_center_down)
  player.set_vel(bound_velocity(player.velocity + accel_per_frame(delta)))
  apply_velocity(delta)
  may_snap_to_floor(delta)

func player_rotation_from_up() -> float:
  return Vector2.UP.angle_to(player.stats.up)

func apply_velocity(delta:float):
  player.set_pos(player.position + player.velocity * delta)

func may_leave_floor(delta:float):
  if player.input.jump_pressed:
    player.stats.state = player.stats.STATE.Airborne
    player.set_vel(player.velocity + (player.stats.up * player.stats.jump_initial_vel.y))
    apply_velocity(delta)
    # disable_casts()
    get_tree().create_timer(0.001).timeout.connect(rotate_if_needed_up, CONNECT_ONE_SHOT)
    # get_tree().create_timer(0.1).timeout.connect(enable_casts)

func enable_casts():
  player.ray_left_down.enabled = true
  player.ray_right_down.enabled = true
  player.ray_center_down.enabled = true

func disable_cast(c:RayCast2D,except=null):
  if c != except: c.enabled = false

func disable_casts(except=null):
  disable_cast(player.ray_left_down, except)
  disable_cast(player.ray_right_down, except)
  disable_cast(player.ray_center_down, except)

func may_snap_to_floor(_delta:float):
  if player.ray_center_down.is_colliding():
    var vel := player.velocity
    var normal := player.ray_center_down.get_collision_normal()
    if vel.is_zero_approx() or abs(normal.angle_to(vel)) > (PI/2.0):
      player.stats.state = player.stats.STATE.Grounded
      # player.stats.state = player.stats.STATE.Off
      snap_to_collision_point_if_needed(player.ray_center_down)


func bound_velocity(v1:=Vector2.ZERO,v2:=Vector2.ZERO,v3:=Vector2.ZERO) -> Vector2:
  var vel = Vector2.ZERO + v1 + v2 + v3
  if player.stats.state == player.stats.STATE.Airborne:
    vel = vel.clamp(-player.stats.max_vel_air, player.stats.max_vel_air)
  elif player.stats.state == player.stats.STATE.Grounded:
    if vel.length() > player.stats.max_vel_ground.length():
      return vel.normalized() * player.stats.max_vel_ground.x
  return vel

# real world xy deceleration (delta vel) per frame
func frict_per_frame(delta):
  if not is_zero_approx(player.input.h) or is_zero_approx(player.velocity.length()): return Vector2.ZERO
  return Vector2(player.stats.frict_ground.x * player.velocity.rotated(PI) * delta)

# real world xy acceleration (delta vel) per frame
func accel_per_frame(delta:float) -> Vector2:
  return (x_accel() * delta) + (y_accel() * delta)

# acceleration (delta vel) per frame alongside the player relative horizontal axis
func h_accel() -> Vector2:
  var result := Vector2.ZERO
  if is_zero_approx(player.input.h) and not is_zero_approx(player.velocity.length()):
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

func _ready() -> void:
  pass
  # Engine.set_time_scale(0.5)

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

