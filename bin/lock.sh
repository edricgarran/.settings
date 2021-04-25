#!/bin/sh
IMAGE="/tmp/lock.png"
grim "${IMAGE}"
convert "${IMAGE}" -scale 25% -blur 0x3 -scale 400% -fill black -colorize 20% "${IMAGE}"
swaylock -efF -s fill -i "${IMAGE}" \
    --ring-color '#00000000' \
    --inside-color '#00000000' \
    --ring-ver-color '#ffaa33' \
    --inside-ver-color '#ffaa33' \
    --ring-clear-color '#33ffaa' \
    --inside-clear-color '#33ffaa' \
    --ring-wrong-color '#ff3333' \
    --inside-wrong-color '#ff3333' \
    --line-uses-inside \
    --line-uses-ring
