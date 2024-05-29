
@tool
extends Node2D


var left_entry_layer : int = 1:
	set(value):
		if value == left_entry_layer:
			return
		# if you deselect the layer nothing happens
		if value :
			# the new layer is the layer in value that is not the old layer
			left_entry_layer = value & ~ left_entry_layer 
			$LeftPart.layer = left_entry_layer
			$Switcher.entry_layer = left_entry_layer

var right_entry_layer : int = 2:
	set(value):
		if value == right_entry_layer:
			return
		# if you deselect the layer nothing happens
		if value :
			# the new layer is the layer in value that is not the old layer
			right_entry_layer = value & ~ right_entry_layer 
			$RightPart.layer = right_entry_layer
			$Switcher.exit_layer = right_entry_layer

func _get_property_list():
	return [
		{
			name = "left_entry_layer", 
			type = 2, 
			hint = 8, 
			hint_string = "", 
			usage = 6,
		},
		{
			name = "right_entry_layer", 
			type = 2, 
			hint = 8, 
			hint_string = "", 
			usage = 6,
		}
	]

