shader_type canvas_item;

uniform sampler2D godot_tex : source_color,hint_default_black;
uniform vec2 target_position = vec2(0.0, 0.0);
uniform float parallax_scale = 0.1;

void fragment() {
  COLOR = texture(TEXTURE, UV);
  COLOR.rgb = smoothstep(0.4, 1.0, COLOR).brb;
  COLOR.rgb += COLOR.rgb;
  COLOR.a = 0.9;
}
