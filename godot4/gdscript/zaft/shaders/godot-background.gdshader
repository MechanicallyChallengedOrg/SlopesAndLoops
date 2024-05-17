shader_type canvas_item;

uniform vec2 target_position = vec2(0.0, 0.0);
uniform float parallax_scale = 0.1;

void fragment() {
  vec2 uv_parallax1 = UV + target_position * parallax_scale * 0.1;
  vec2 uv_parallax2 = UV + target_position * parallax_scale * 0.5;
  vec2 uv_parallax3 = UV + target_position * parallax_scale * 0.25;
  COLOR = texture(TEXTURE, uv_parallax1).brrr;
    // texture(TEXTURE, uv_parallax2).gggg +
    // texture(TEXTURE, uv_parallax3).bbbb;
  COLOR.a = 0.1;
}
