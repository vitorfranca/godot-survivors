shader_type canvas_item;

// Called for every vertex the material is visible on.
void vertex() {
}

uniform float lerp_percent: hint_range(0.0, 1.0, 0.05);

// Called for every pixel the material is visible on.
void fragment() {
	vec3 texture_color = texture(TEXTURE, UV).rgb;
	vec3 flash_color = vec3(1, 0, 0);
	COLOR.rgb = mix(texture_color, flash_color, lerp_percent);
}

// Called for every pixel for every light affecting the CanvasItem.
// Uncomment to replace the default light processing function with this one.
//void light() {
//}
