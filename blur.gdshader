shader_type canvas_item;

uniform sampler2D noise : repeat_enable;
uniform sampler2D screen_texture : hint_screen_texture, repeat_enable;

uniform vec2 offset_per_time = vec2(0.1, 0.1);


void fragment() {
	vec4 offset = texture(noise, UV + offset_per_time * TIME);
    vec4 screen = texture(screen_texture, SCREEN_UV + 0.07 * (offset.rr - 0.5));
	COLOR = screen;
}
