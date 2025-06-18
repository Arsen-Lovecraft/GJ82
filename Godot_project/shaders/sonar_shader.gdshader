shader_type canvas_item;

uniform float speed = 2.0;
uniform float strength = 0.5;

void fragment() {
    // Pulsing brightness effect
    float pulse = sin(TIME * speed) * strength + 1.0;
    COLOR = texture(TEXTURE, UV) * vec4(pulse, pulse, pulse, 1.0);
}