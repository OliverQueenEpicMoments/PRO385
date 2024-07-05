shader_type canvas_item;

uniform float Amount = 40.0;

//void vertex() {
	// Called for every vertex the material is visible on.
//}

void fragment() {
	vec2 uv = UV * 0.05;
	float A = fract(sin(dot(uv, vec2(12.9898, 78.233) * TIME)) * 438.5453) * 1.9;
	vec4 Col = texture(TEXTURE, UV);
	Col.a *= pow(A, Amount);
	COLOR.a = Col.a;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
