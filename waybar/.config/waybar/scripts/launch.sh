#!/bin/bash

killall -9 waybar
waybar &
systemctl --user reload swaync

