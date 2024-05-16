class_name PlayerCharacterScene extends CharacterBody2D

@export var stats : PlayerCharacterStatsResource = PlayerCharacterStatsResource.new()
@onready var input : PlayerCharacterInputNode = $Logic/Input
@onready var movement : PlayerCharacterMovementNode = $Logic/Movement
@onready var ray_center_down : RayCast2D = $Rays/CenterDown
@onready var sprite : Sprite2D = $Visual/Head

func _process(_delta: float) -> void:
  if ray_center_down.is_colliding():
    print(ray_center_down.get_collider())
