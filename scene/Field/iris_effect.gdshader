shader_type canvas_item;
uniform float radius : hint_range(0, 256) = 256.0;
uniform vec2 center = vec2(128.0, 128.0);

void fragment() {
	float x = UV.x * 256.0;
	float y = UV.y * 256.0;

	float alpha = float((x - center.x) * (x - center.x) + (y - center.y) * (y - center.y) > radius * radius);
	COLOR.a = alpha;
}
