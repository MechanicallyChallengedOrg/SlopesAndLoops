class_name LoopScene extends Node2D

@onready var polygons : Node2D = $Polygons
@onready var bodies := PolygonColliderSetupNode.new()
@onready var markers : LoopPickupMarkersNode = $Markers

# Activation Zone:
# When the player passes through the middle of the loop, no matter from which direction,
# the character will go through this area and activate both walls of the loop.
# This turns the loop into a prison of sorts, and the player can only go out in 2 ways:
# - A) Jumping on the slope of the loop, which just lets the player fall through and then go out
# - B) Going around the loop at enough speed so the loop can be completed, which lets the player out on the other side
@onready var activation_zone : Area2D = $WallActivationZone

# Deactivation Zones:
# Because the implementation includes a solid wall around the loop,
# these zones are added to deactivate that collision as the player passes by,
# so the player can enter the loop. This could also be achieved with one way
# collisions, but I wanted to demonstrate a different approach, that might be more
# flexible in some situations.
@onready var deactivation_zone_right : Area2D = $WallDeactivationZoneRight
@onready var deactivation_zone_left : Area2D = $WallDeactivationZoneLeft

# Wall/Floor/Ground Polygons:
# These are just polygons drawn on the screen for the sake of
# having some easy to make terrain for the demo.
# Polygons don't have physics and you cannot add colliders to them,
# for the demo I just wrote a simple script that creates a matching StaticBody
# with a Polygon collision shape using the same vertex data as the visual polygon
var wall_left_poly : Polygon2D
var wall_right_poly : Polygon2D
var ground_poly : Polygon2D
var ceiling_poly : Polygon2D

# Loopy Static Bodies
# These are automatically generated based on the polygons above (the polygons are drawn in the editor)
var wall_left_body : LoopyStaticBody2D
var wall_right_body : LoopyStaticBody2D
var ground_body : LoopyStaticBody2D
var ceiling_body : LoopyStaticBody2D

# specifying the type of _p here to provoke a crash if layers/masks are wrong
func on_body_entered_activation_zone(_p:PlayerCharacterScene):
  enable_left_wall()
  enable_right_wall()

func on_body_entered_deactivation_zone(_p:PlayerCharacterScene, b:LoopyStaticBody2D):
  b.disable_loop_collision()

func enable_left_wall(): if wall_left_body != null: wall_left_body.enable_loop_collision()
func enable_right_wall(): if wall_right_body != null: wall_right_body.enable_loop_collision()
func disable_left_wall(): if wall_left_body != null: wall_left_body.disable_loop_collision()
func disable_right_wall(): if wall_right_body != null: wall_right_body.disable_loop_collision()

func on_marker_timed_out():
  activation_zone.monitoring = true

func on_last_marker_picked_up(p:PlayerCharacterScene):
  activation_zone.monitoring = false
  if p.velocity.x > 0: wall_right_body.disable_loop_collision()
  if p.velocity.x < 0: wall_left_body.disable_loop_collision()
  get_tree().create_timer(1).timeout.connect(func (): activation_zone.monitoring = true, CONNECT_ONE_SHOT)

func on_first_marker_picked_up(_num_picked_up:int,_num_required:int):
  activation_zone.monitoring = true

func setup_marker_signals():
  markers.marker_picked_up.connect(on_first_marker_picked_up)
  markers.all_markers_picked_up.connect(on_last_marker_picked_up)
  markers.marker_timeout.connect(on_marker_timed_out)

func setup_zone_signals():
  activation_zone.body_entered.connect(on_body_entered_activation_zone)
  deactivation_zone_right.body_entered.connect(on_body_entered_deactivation_zone.bind(wall_right_body))
  deactivation_zone_left.body_entered.connect(on_body_entered_deactivation_zone.bind(wall_left_body))

func _ready() -> void:
  add_child(bodies)
  bodies.copy_polygons_to_bodies(polygons)
  __util.read_bodies_and_polies(self, bodies, polygons)
  disable_left_wall()
  disable_right_wall()
  ground_body.loop_collision_can_be_disabled = false
  ceiling_body.loop_collision_can_be_disabled = false
  setup_zone_signals()
  setup_marker_signals()
