
#!/bin/bash

SHADER="$HOME/.config/hypr/shaders/invert-colors.glsl"

CURRENT=$(hyprctl getoption decoration.screen_shader -j | jq -r '.str')

if [[ "$CURRENT" == "$SHADER" ]]; then
    hyprctl eval 'hl.config({ decoration = { screen_shader = "" } })'
else
    hyprctl eval "hl.config({ decoration = { screen_shader = \"$SHADER\" } })"
fi

