-- Apps
local apps = {
terminal = "kitty",
editor = "emacsclient -c -a emacs",
music = "kitty -t cmus --class cmus,cmus -e cmus",
chat = "kitty -t gomuks --class gomuks,gomuks -e gomuks",
game = "retroarch",
file = "kitty -t vifm --class vifm,vifm -e ./.config/vifm/scripts/vifmrun",
browser = "firefox",
}
return apps
