shader_type canvas_item;

uniform vec2 target_position = vec2(0.0, 0.0);
uniform float parallax_scale = 0.1;

void fragment() {
  vec2 uv_parallax1 = UV + target_position * parallax_scale * 0.5;
  COLOR = texture(TEXTURE, uv_parallax1).brrr;
  COLOR.a = 0.1;
}
