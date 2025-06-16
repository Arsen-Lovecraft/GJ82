shader_type canvas_item;

uniform vec2 reveal_origin ; // In screen UVs (0-1)
uniform vec2 direction = vec2(1.0, 0.0); // Flashlight direction (normalized)
uniform float radius = 0.0;
uniform float softness = 200.0;
uniform float angle = 45.0; // Cone half-angle in degrees
uniform float hide = 1.0;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
    // Convert SCREEN_UV to pixel position
    vec2 pixel_pos = SCREEN_UV * vec2(textureSize(SCREEN_TEXTURE, 0));
    vec2 origin_pos = reveal_origin * vec2(textureSize(SCREEN_TEXTURE, 0));

    vec2 to_pixel = normalize(pixel_pos - origin_pos);
    float dist = distance(pixel_pos, origin_pos);

    // Angle check (cosine comparison for cone)
    float angle_cos = cos(radians(angle));
    float dp = dot(to_pixel, direction);

    // Reveal based on both radius AND cone angle
    float in_cone = smoothstep(angle_cos - 0.05, angle_cos + 0.05, dp);
    float in_radius = smoothstep(radius + softness, radius, dist);

    float reveal = in_cone * in_radius * hide;

    vec4 tex = texture(TEXTURE, UV);
    tex.a *= reveal;
    COLOR = tex;
}