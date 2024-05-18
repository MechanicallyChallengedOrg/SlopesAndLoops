class_name DebugScene extends Control

# (i) INFO (i)
# These child nodes are being cached/exposed here because
# other parts of the game interact with them.
# ---
# Namely:
# The debugger node updates player's stats/input in real time,
# as well as being able to enter "gotta go fast" mode
# and show/hide the telemetry/input UIs.
# ---
# This is an alternative for exposing the nodes via unique IDSs
# and it has PROs and CONs. How you expose (or not) internal
# nodes in a scene to other parts of the game is one of those things
# where there are many many many ways of doing it,
# be sure to experiment and find what works for you!

@onready var godot_godot_fast: CheckButton = $TopLeft/VBox/GodotGodotFast
@onready var telemetry: CheckButton = $TopLeft/VBox/Telemetry
@onready var player_stats: Label = $TopLeft/VBox/PlayerStats
@onready var input: CheckButton = $TopLeft/VBox/Input
@onready var player_input: Label = $TopLeft/VBox/PlayerInput

