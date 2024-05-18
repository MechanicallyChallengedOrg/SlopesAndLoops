shader_type canvas_item;

uniform float alpha_multiplier: hint_range(0.0f, 1.0f, 0.1f) = 1.0f;

void fragment() {
  COLOR = texture(TEXTURE, UV);
  COLOR.rgb = smoothstep(0.2, 0.9, COLOR).brb * 0.75f;
  COLOR.rgb = mix(COLOR.rgb, vec3(0.3, 0.0, 0.3), 1.0 - COLOR.b);
  COLOR.a = 0.9f;
  // COLOR.a *= 0.5f;
  COLOR.a *= alpha_multiplier;
}
