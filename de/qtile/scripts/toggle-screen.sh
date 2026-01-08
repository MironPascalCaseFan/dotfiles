#!/bin/bash
STATE=$(xset -q | grep "Monitor is" | awk '{print $3}')
if [ "$STATE" = "On" ]; then
    xset dpms force off
else
    xset dpms force on
fi
