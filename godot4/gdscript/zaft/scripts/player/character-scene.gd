class_name PlayerCharacterScene extends CharacterBody2D

@export var stats : PlayerCharacterStatsResource = PlayerCharacterStatsResource.new()
@onready var input : PlayerCharacterInputNode = $Logic/Input
@onready var ray_center_down : RayCast2D = $Rays/CenterDown
@onready var ray_right_down : RayCast2D = $Rays/RightDown
@onready var ray_left_down : RayCast2D = $Rays/LeftDown
@onready var sprite : Sprite2D = $Visual/Head

func _enter_tree() -> void:
  stats.player = self

func _ready() -> void:
  floor_max_angle = deg_to_rad(89)
  floor_constant_speed = deg_to_rad(89)
  floor_snap_length = 1.5
  max_slides = 8
