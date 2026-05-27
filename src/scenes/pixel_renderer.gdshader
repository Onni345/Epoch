shader_type spatial;

render_mode unshaded, fog_disabled, depth_draw_never;

uniform sampler2D screen_texture : hint_screen_texture;
uniform sampler2D depth_texture : hint_depth_texture;
uniform sampler2D normal_texture : hint_normal_roughness_texture;

uniform float depth_threshold : hint_range(0.0001, 0.1) = 0.01;
uniform float normal_threshold : hint_range(0.01, 1.0) = 0.2;

uniform float step_count = 5.0;
uniform float edge_thickness = 1.0;

vec3 sample_toon(sampler2D tex, vec2 uv) {

    vec3 c = texture(tex, uv).rgb;

    float lum =
        dot(c, vec3(0.2126, 0.7152, 0.0722));

    float stepped =
        floor(lum * step_count) / step_count;

    float shade =
        mix(0.5, 1.2, stepped);

    return c * shade;
}

void fragment() {
    vec2 px = (1.0 / VIEWPORT_SIZE) * edge_thickness;

	// 1. step based lighting
	vec4 base_color = texture(screen_texture, SCREEN_UV);
	vec3 stepped_color = sample_toon(screen_texture, SCREEN_UV);

	vec2 offsets[4] = vec2[](
        vec2(px.x, 0.0),
        vec2(-px.x, 0.0),
        vec2(0.0, px.y),
        vec2(0.0, -px.y)
    );

    float center_depth = texture(depth_texture, SCREEN_UV).r;

    vec3 center_normal = texture(normal_texture, SCREEN_UV).rgb;
    float max_depth_diff = 0.0;
    float max_normal_diff = 0.0;

    for (int i = 0; i < 4; i++) {
        vec2 suv = SCREEN_UV + offsets[i];

        float sample_depth = texture(depth_texture, suv).r;
        vec3 sample_normal = texture(normal_texture, suv).rgb;
        float depth_diff = abs(center_depth - sample_depth);
        float normal_diff = distance(center_normal, sample_normal);

        max_depth_diff = max(max_depth_diff, depth_diff);
        max_normal_diff = max(max_normal_diff, normal_diff);
    }

	bool depth_edge =
        max_depth_diff > depth_threshold;

    bool normal_edge =
        max_normal_diff > normal_threshold;

    if (depth_edge || normal_edge) {
        ALBEDO = vec3(0.05);
    }
    else {
        ALBEDO = stepped_color;
    }

	ALPHA = base_color.a;
}

void vertex() {
    POSITION = vec4(VERTEX.xy, 1.0, 1.0);
}