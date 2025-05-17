shader_type canvas_item;

uniform float lerp_percent;

void fragment() {
	vec4 texture_color = texture(TEXTURE, UV);


	vec4 final_color = mix(texture_color, vec4(1.0, 1.0, 1.0, texture_color.a), lerp_percent);
	COLOR.rgb = final_color.rgb;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
