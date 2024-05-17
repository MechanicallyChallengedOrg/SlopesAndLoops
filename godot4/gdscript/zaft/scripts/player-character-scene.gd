class_name PlayerCharacterScene extends CharacterBody2D

@export var stats : PlayerCharacterStatsResource = PlayerCharacterStatsResource.new()
@onready var input : PlayerCharacterInputNode = $Logic/Input
@onready var movement : PlayerCharacterMovementNode = $Logic/Movement
@onready var ray_center_down : RayCast2D = $Rays/CenterDown
@onready var ray_center_down_ext : RayCast2D = $Rays/CenterDownExt
@onready var ray_right_down : RayCast2D = $Rays/RightDown
@onready var ray_left_down : RayCast2D = $Rays/LeftDown
@onready var sprite : Sprite2D = $Visual/Head

func set_vel(vel:=Vector2.ZERO) -> Vector2: velocity = vel; stats.vel = vel; return vel
func set_pos(pos:=Vector2.ZERO) -> Vector2: position = pos; stats.pos = pos; return pos
