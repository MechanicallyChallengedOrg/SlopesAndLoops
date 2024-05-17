class_name LoopPrisonScene extends Node2D

@onready var polygons : Node2D = $Polygons

func _ready() -> void:
  var setup := PolygonColliderSetupNode.new()
  add_child(setup)
  setup.copy_polygons_to_bodies(polygons)

