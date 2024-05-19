shader_type canvas_item;

uniform vec2 bobbing_amplitude = vec2(0.0, 8.0);
uniform vec2 bobbing_speed = vec2(0.0, 4.0);
uniform float spinning_speed = 2.0;

void vertex() {
  vec2 vertex = VERTEX;
  vertex += sin(TIME * bobbing_speed) * bobbing_amplitude;
  float spin = sin(TIME * spinning_speed);
  vertex.x *= clamp(spin * spin, 0.01, 0.95);
  VERTEX = vertex;
}

void fragment() {
  vec2 uv = UV;
  vec4 color = texture(TEXTURE, uv);
  color.rgba = color.bbrb;
  COLOR = color;
}
