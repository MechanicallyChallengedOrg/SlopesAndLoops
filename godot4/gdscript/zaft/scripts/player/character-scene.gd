class_name PlayerCharacterScene extends CharacterBody2D

signal after_physics_update(delta:float)
signal before_physics_update(delta:float)

@export var stats : PlayerCharacterStatsResource = PlayerCharacterStatsResource.new()
@onready var input : PlayerCharacterInputNode = $Logic/Input
@onready var ray_center_down : RayCast2D = $Rays/CenterDown
@onready var ray_center_down_ext : RayCast2D = $Rays/CenterDownExt
@onready var ray_right_down : RayCast2D = $Rays/RightDown
@onready var ray_left_down : RayCast2D = $Rays/LeftDown
@onready var sprite : Sprite2D = $Visual/Head

func _enter_tree() -> void:
  stats.player = self

func _ready() -> void:
  floor_max_angle = deg_to_rad(89)
  floor_snap_length = 16.0

func _physics_process(delta: float) -> void:
  before_physics_update.emit(delta)
  move_and_slide()
  after_physics_update.emit(delta)
