@tool
extends EditorPlugin


func _enter_tree() -> void:
	InputMap.add_action("slope_body_2d_right", InputMap.action_get_deadzone("ui_right"))
	InputMap.add_action("slope_body_2d_left", InputMap.action_get_deadzone("ui_left"))
	for event in InputMap.action_get_events("ui_right"):
		InputMap.action_add_event("slope_body_2d_right", event)
	for event in InputMap.action_get_events("ui_left"):
		InputMap.action_add_event("slope_body_2d_left", event)

func _exit_tree() -> void:
	InputMap.erase_action("slope_body_2d_right")
	InputMap.erase_action("slope_body_2d_left")
