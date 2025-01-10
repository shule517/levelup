shader_type canvas_item;

uniform bool enabled = true;
uniform bool is_selected = false;
uniform vec4 modulate;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	if (enabled) {
	    // UV座標を取得
	    float y_coord_uv = UV.y;

	    // スプライトのテクスチャサイズを取得 (ピクセル単位)
	    ivec2 texture_size = textureSize(TEXTURE, 0);
	    float y_coord_pixels = y_coord_uv * float(texture_size.y);

		// Y座標を整数値に変換
	    float y_coord_rounded = floor(y_coord_pixels);

	    // 偶奇判定 (ピクセル座標が偶数か奇数かで切り替え)
	    if (mod(y_coord_rounded, 2.0) == 0.0) {
	        // 不透過 (元のテクスチャの色を表示)
	        COLOR = texture(TEXTURE, UV);
	    } else {
	        // 透過 (アルファ値を0に設定)
	        COLOR = vec4(0.0, 0.0, 0.0, 0.0);
	    }
	}

	if (enabled) {
		if (is_selected) {
			// 定義
			float outline_width = 1.0;
			vec4 outline_color = vec4(1.0, 1.0, 1.0, 1.0);

			// スプライトサイズの割合に変換する
			float size = outline_width * 1.0 / float(textureSize(TEXTURE, 0).x);

			// スプライトの色を取得
			vec4 sprite_color = texture(TEXTURE, UV);

			// アルファ値を4倍した値で引く
			float alpha = -4.0 * sprite_color.a;

			// 4方向の平均を足し込む
			alpha += texture(TEXTURE, UV + vec2(size, 0.0)).a;
			alpha += texture(TEXTURE, UV + vec2(-size, 0.0)).a;
			alpha += texture(TEXTURE, UV + vec2(0.0, size)).a;
			alpha += texture(TEXTURE, UV + vec2(0.0, -size)).a;

			// アウトラインの色とアルファ値を合成
			float blend_a = clamp(alpha, 0.0, 1.0); // 元のスプライトとの合成アルファ値
			float outline_a = abs(alpha); // 輪郭線のアルファ値.
			vec4 final_color = mix(sprite_color, outline_color, blend_a);
			COLOR = vec4(final_color.rgb, clamp(sprite_color.a + outline_a, 0.0, 1.0)) * modulate;
		}
	}
}
