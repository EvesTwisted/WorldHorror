shader_type canvas_item;

uniform float stress = 0.0;
uniform float speed = 5.0;
uniform float intensity = 0.1;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

float random(vec2 uv) {
    return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
    vec2 uv = SCREEN_UV;
    float time = TIME * speed;

    // Screen tearing effect
    float tear = sin(uv.y * 10.0 + time) * 0.01 * stress;
    uv.x += tear;

    // Static noise
    float noise = (random(uv + vec2(time, time)) - 0.5) * intensity * stress;

    // Combine with screen texture
    vec4 color = texture(SCREEN_TEXTURE, uv);
    color.rgb += noise;

    COLOR = color;
}
