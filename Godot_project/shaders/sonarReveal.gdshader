shader_type canvas_item;

uniform vec2 reveal_origin;
uniform vec2 direction = vec2(1.0, 0.0); // Normalized
uniform float radius = 0.0;
uniform float softness = 50.0;
uniform float angle = 45.0; // Cone half-angle in degrees
uniform float fade = 1.0;

void fragment() {
    vec2 screen_size = vec2(textureSize(TEXTURE, 0));
    vec2 pixel_pos = SCREEN_UV * screen_size;
    vec2 origin_pos = reveal_origin * screen_size;

    vec2 to_pixel = normalize(pixel_pos - origin_pos);
    float dist = distance(pixel_pos, origin_pos);

    float angle_cos = cos(radians(angle));
    float dp = dot(to_pixel, direction);

    float in_cone = smoothstep(angle_cos - 0.05, angle_cos + 0.05, dp);
    float in_radius = smoothstep(radius + softness, radius, dist);

    float reveal = in_cone * in_radius;

    vec4 tex = texture(TEXTURE, UV);
    tex.a *= reveal * fade;
    COLOR = tex;
}
