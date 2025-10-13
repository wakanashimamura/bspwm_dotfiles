#!/bin/sh

if [ "$1" = "-menu" ]; then
  dir="$HOME/.config/rofi/power_menu.rasi"
fi

if [ "$1" = "-menu_bar" ]; then
  dir="$HOME/.config/rofi/power_menu_bar.rasi"
fi

shutdowm=' Shutdown'
reboot=' Reboot'
lock=' Lock'
logout=' Logout'

chosen=$(printf '%s\n' "$shutdowm" "$reboot" "$lock" "$logout" \
         | rofi -dmenu -config "$dir" -p "Power Menu")

case "$chosen" in
  "$shutdowm") systemctl poweroff ;;
  "$reboot")   systemctl reboot ;;
  #"$lock")    # Add lockscreen command ;;
  #"$logout")  # Add logout command ;;
esac
