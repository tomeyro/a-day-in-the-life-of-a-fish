shader_type canvas_item;

uniform float percentage = 100.0;

const float shake = 3.0;

float rand(vec2 val) {
	float time = round(TIME * 10.0) / 10.0;
	return fract(sin(dot(vec2(time, time), vec2(12.9898, 4.1414) + val)) * 43758.5453);
}

void vertex() {
	VERTEX += vec2(shake * rand(VERTEX), shake * rand(VERTEX));
}

void fragment() {
	if (percentage < 100.0) {
		float p = (800.0 * percentage) / 100.0;
		if (VERTEX.x > p) {
			COLOR.a = 0.2;
		}
	}
}