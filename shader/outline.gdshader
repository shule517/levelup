shader_type canvas_item;

uniform bool enabled = true;
uniform bool is_selected = false;

void fragment() {
	// 現在のピクセルの色を取得
	vec4 sprite_color = texture(TEXTURE, UV);

	// 通常の描画
	if (!enabled || !is_selected || sprite_color.a > 0.0) {
		COLOR = sprite_color;
	} else {
		// アウトラインの処理
		vec4 outline_color = vec4(1.0, 1.0, 1.0, 1.0); // 白色のアウトライン
		vec2 texel_size = 1.0 / vec2(textureSize(TEXTURE, 0)); // テクセルサイズ

		// 4方向の隣接ピクセルのアルファ値を取得
		float alpha_right = texture(TEXTURE, UV + vec2(texel_size.x, 0.0)).a;
		float alpha_left = texture(TEXTURE, UV - vec2(texel_size.x, 0.0)).a;
		float alpha_top = texture(TEXTURE, UV + vec2(0.0, texel_size.y)).a;
		float alpha_bottom = texture(TEXTURE, UV - vec2(0.0, texel_size.y)).a;

		// 4方向の合計値でアウトラインを判定
		float outline_alpha = clamp(alpha_right + alpha_left + alpha_top + alpha_bottom, 0.0, 1.0);

		// アウトラインの色を適用
		COLOR = vec4(outline_color.rgb, outline_alpha);
	}
}
