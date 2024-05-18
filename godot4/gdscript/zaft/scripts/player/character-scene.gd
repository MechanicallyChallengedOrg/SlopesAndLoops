class_name PlayerCharacterScene extends CharacterBody2D

@export var stats : PlayerCharacterStatsResource = PlayerCharacterStatsResource.new()
@onready var input : PlayerCharacterInputNode = $Logic/Input
@onready var ray_center_down : RayCast2D = $Rays/CenterDown
@onready var ray_right_down : RayCast2D = $Rays/RightDown
@onready var ray_left_down : RayCast2D = $Rays/LeftDown
@onready var sprite : Sprite2D = $Visual/Head

func _ready() -> void:
  floor_max_angle = __config.MAX_SLOPE_ANGLE
  floor_snap_length = __config.SNAP_LENGTH
  max_slides = __config.MAX_SLIDES
  floor_constant_speed = true
