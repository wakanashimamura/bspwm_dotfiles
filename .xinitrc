setxkbmap -option caps:escape

xset -dpms
xset s off

exec sxhkd & 
exec bspwm
