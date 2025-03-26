shader_type canvas_item;

uniform float strength : hint_range(0.0, 10.0) = 2.0;
uniform sampler2D screen_texture : hint_screen_texture;

void fragment() {
    vec2 uv = SCREEN_UV;
    vec2 center = vec2(0.5, 0.5);
    vec2 dir = uv - center;
    float dist = length(dir);

    // 距離に応じてズレ量を増やす
    vec2 offset = normalize(dir) * dist * strength * 0.005;

    // RGBごとにずらして取得
    float r = texture(screen_texture, uv + offset).r;
    float g = texture(screen_texture, uv).g;
    float b = texture(screen_texture, uv - offset).b;

    COLOR = vec4(r, g, b, 1.0);
}
