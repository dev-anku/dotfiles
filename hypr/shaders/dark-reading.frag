#version 300 es

precision highp float;

in vec2 v_texcoord;
layout(location = 0) out vec4 fragColor;

uniform sampler2D tex;

void main() {
    vec4 c = texture(tex, v_texcoord);

    // Perceived brightness
    float luma = dot(c.rgb, vec3(0.2126, 0.7152, 0.0722));

    // Invert brightness
    float dark = 1.0 - luma;

    // Strong contrast
    dark = smoothstep(0.05, 0.95, dark);

    // Dark background -> light text
    vec3 result = vec3(0.08 + dark * 0.82);

    // Preserve a small amount of the original color
    result = mix(result, c.rgb, 0.08);

    fragColor = vec4(result, c.a);
}
