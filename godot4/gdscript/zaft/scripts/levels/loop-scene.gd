class_name LoopScene extends Node2D

@onready var polygons : Node2D = $Polygons
@onready var bodies := PolygonColliderSetupNode.new()
@onready var activation_zone : Area2D = $WallActivationZone
@onready var deactivation_zone_right : Area2D = $WallDeactivationZoneRight
@onready var deactivation_zone_left : Area2D = $WallDeactivationZoneLeft

var wall_left_body : LoopyStaticBody2D
var wall_right_body : LoopyStaticBody2D
var ground_body : LoopyStaticBody2D
var ceiling_body : LoopyStaticBody2D

var wall_left_poly : Polygon2D
var wall_right_poly : Polygon2D
var ground_poly : Polygon2D
var ceiling_poly : Polygon2D

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
