shader_type canvas_item;

uniform sampler2D godot_tex : source_color,hint_default_black;
uniform vec2 target_position = vec2(0.0, 0.0);
uniform float parallax_scale = 0.1;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
  COLOR = texture(TEXTURE, UV);
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
