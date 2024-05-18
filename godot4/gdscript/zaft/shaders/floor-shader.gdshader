shader_type canvas_item;

uniform float alpha_multiplier: hint_range(0.0f, 1.0f, 0.1f) = 1.0f;

void fragment() {
  COLOR = texture(TEXTURE, UV);
  COLOR.rgb = smoothstep(0.4, 1.0, COLOR).brb;
  COLOR.rgb += COLOR.rgb;
  COLOR.a = 0.9;
  COLOR.a *= alpha_multiplier;
}
