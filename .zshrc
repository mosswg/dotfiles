# Greeting
echo "welcome to the void"

# Prompt
# PROMPT="%F{red}┌[%f%F{cyan}%m%f%F{red}]─[%f%F{yellow}%D{%H:%M-%d/%m}%f%F{red}]─[%f%F{magenta}%d%f%F{red}]%f"$'\n'"%F{red}└╼%f%F{green}$USER%f%F{yellow}$%f"
# Export PATH$
export PATH=~/.local/bin:/snap/bin:/usr/sandbox/:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/usr/share/games:/usr/local/sbin:/usr/sbin:/sbin:/usr/local/texlive/2022/bin/x86_64-linux:~/.emacs.d/bin:$PATH
export JDK_HOME=/usr/lib/jvm/openjdk17
export GPG_TTY=$(tty)


# alias
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias batt='upower -i /org/freedesktop/UPower/devices/battery_BAT1'
alias checkbright='xrandr --prop --verbose | grep -A10 " connected" | grep "Brightness"'
alias setbright='xrandr --output eDP1 --brightness '
#####################################################
# Auto completion / suggestion
# Mixing zsh-autocomplete and zsh-autosuggestions
# Requires: zsh-autocomplete (custom packaging by Parrot Team)
# Jobs: suggest files / foldername / histsory bellow the prompt
# Requires: zsh-autosuggestions (packaging by Debian Team)
# Jobs: Fish-like suggestion for command history
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh
# Select all suggestion instead of top on result only
zstyle ':autocomplete:tab:*' insert-unambiguous yes
zstyle ':autocomplete:tab:*' widget-style menu-select
zstyle ':autocomplete:*' min-input 2
# bindkey $key[Up] up-line-or-history
# bindkey $key[Down] down-line-or-history
bindkey "^[[1;5A" vi-beginning-of-line
bindkey "^[[1;5B" vi-end-of-line
bindkey "^[[1;5C" emacs-forward-word
bindkey "^[[1;5D" emacs-backward-word
bindkey '^H' backward-kill-word
bindkey '5~' kill-word

bindkey "^[[3~" delete-char


##################################################
# Fish like syntax highlighting
# Requires "zsh-syntax-highlighting" from apt
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Save type history for completion and easier life
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# Useful alias for benchmarking programs
# require install package "time" sudo apt install time
# alias time="/usr/bin/time -f '\t%E real,\t%U user,\t%S sys,\t%K amem,\t%M mmem'"
# Display last command interminal
echo -en "\e]2;zsh\a"
preexec () { print -Pn "\e]0;$1 - zsh\a" }
##       ____             __
##      / __ \_________ _/ /_____
##     / / / / ___/ __ `/ //_/ _ \
##    / /_/ / /  / /_/ / ,< /  __/  Clay Gomera (Drake)
##   /_____/_/   \__,_/_/|_|\___/   My custom bash config
##

### EXPORT ###
export TERM="xterm-256color"                      # getting proper colors
export HISTCONTROL=ignoredups:erasedups           # no duplicate entries

# use bash-completion, if available
[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && \
    . /usr/share/bash-completion/bash_completion

# if not running interactively, don't do anything
[[ $- != *i* ]] && return

# use neovim for vim if present.
[ -x "$(command -v nvim)" ] && alias vim="nvim" vimdiff="nvim -d"

# use $XINITRC variable if file exists.
[ -f "$XINITRC" ] && alias startx="startx $XINITRC"

### SET VI MODE ###
# Comment this line out to enable default emacs-like bindings
#set -o vi
#bindkey -m vi-command 'Control-l: clear-screen'
#bindkey -m vi-insert 'Control-l: clear-screen'

### PATH ###
if [ -d "$HOME/.bin" ] ;
  then PATH="$HOME/.bin:$PATH"
fi
if [ -d "$HOME/.local/bin" ] ;
  then PATH="$HOME/.local/bin:$PATH"
fi
if [ -d "$HOME/Applications" ] ;
  then PATH="$HOME/Applications:$PATH"
fi
if [ -d "$HOME/.emacs.d/bin" ] ;
  then PATH="$HOME/.emacs.d/bin:$PATH"
fi

### CHANGE TITLE OF TERMINALS ###
case ${TERM} in
  xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|alacritty|st|konsole*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
        ;;
  screen*)
    PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
    ;;
esac

### SHOPT ###
setopt autocd # change to named directory
setopt dotglob
setopt histappend # do not overwrite history


# ignore upper and lowercase when TAB completion
bindkey "set completion-ignore-case on"

# sudo not required for some system commands
for command in cryptsetup mount umount poweroff reboot ; do
alias $command="sudo $command"
done; unset command

### ARCHIVE EXTRACTION ###
# usage: ex <file>
ex ()
{
  if [ -f "$1" ] ; then
    case $1 in
      *.tar.bz2)   tar xjf "$1"   ;;
      *.tar.gz)    tar xzf "$1"   ;;
      *.bz2)       bunzip2 "$1"   ;;
      *.rar)       unrar x "$1"   ;;
      *.gz)        gunzip "$1"    ;;
      *.tar)       tar xf "$1"    ;;
      *.tbz2)      tar xjf "$1"   ;;
      *.tgz)       tar xzf "$1"   ;;
      *.zip)       unzip "$1"     ;;
      *.Z)         uncompress "$1";;
      *.7z)        7zz x "$1"     ;;
      *.deb)       ar x "$1"      ;;
      *.tar.xz)    tar xf "$1"    ;;
      *.tar.zst)   unzstd "$1"    ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

### ALIASES ###
# navigation
up () {
  local d=""
  local limit="$1"

  # Default to limit of 1
  if [ -z "$limit" ] || [ "$limit" -le 0 ]; then
    limit=1
  fi

  for ((i=1;i<=limit;i++)); do
    d="../$d"
  done

  # perform cd. Show error if cd fails
  if ! cd "$d"; then
    echo "Couldn't go up $limit dirs.";
  fi
}

# cd
alias \
  ..="cd .." \
  .2="cd ../.." \
  .3="cd ../../.." \
  .4="cd ../../../.." \
  .5="cd ../../../../.."

# bat as cat
[ -x "$(command -v bat)" ] && alias cat="bat"

# Changing "ls" to "exa"
alias \
  ls="exa -al --color=always --group-directories-first" \
  la="exa -a --color=always --group-directories-first" \
  ll="exa -l --color=always --group-directories-first" \
  lt="exa -aT --color=always --group-directories-first" \
  l.='exa -a | egrep "^\."'

# function to detect os and assign aliases to package managers
os=$(grep NAME /etc/os-release | head -1 | cut -d'=' -f2 | sed 's/["]//g')
if [ "${os}" = "Arch Linux" ]; then
    alias \
      pac-up="paru -Syyu" \
      pac-get="paru -S" \
      pac-rmv="paru -Rcns" \
      pac-rmv-sec="paru -R" \
      pac-qry="paru -Ss" \
      pac-cln="paru -Scc"
elif [ "${os}" = "Void Linux" ]; then
    alias \
      xb-up="sudo vpm update -Su && xcheckrestart" \
      xb-get="sudo vpm install" \
      xb-rmv="sudo vpm remove -R" \
      xb-rmv-sec="sudo vpm remove" \
      xb-qry="sudo vpm search" \
      xb-cln="sudo vpm cleanup -o"
elif [ "${os}" = "Fedora Linux" ]; then
    alias \
      dnf-up="sudo dnf update" \
      dnf-get="sudo dnf install" \
      dnf-rmv="sudo dnf remove" \
      dnf-cln="sudo dnf autoremove"
fi

# colorize grep output (good for log files)
alias \
  grep="grep --color=auto" \
  egrep="egrep --color=auto" \
  fgrep="fgrep --color=auto"

# git
alias \
  addup="git add -u" \
  addall="git add ." \
  branch="git branch" \
  checkout="git checkout" \
  clone="git clone" \
  commit="git commit -m" \
#  fetch="git fetch" \
  pull="git pull origin" \
  push="git push origin" \
  stat="git status" \
  tag="git tag" \
  newtag="git tag -a"

# adding flags
alias \
  df="df -h" \
  free="free -m" \
  newsboat="newsboat -u ~/.config/newsboat/urls"

# multimedia scripts
alias \
  fli="flix-cli" \
  ani="ani-cli" \
  aniq="ani-cli -q"

# audio
alias \
  mx="pulsemixer" \
  amx="alsamixer" \
  mk="cmus" \
  ms="cmus" \
  music="cmus"

# power management
if [ "${os}" = "Arch Linux" ]; then
    alias \
      po="systemctl poweroff" \
      sp="systemctl suspend" \
      rb="systemctl reboot"
elif [ "${os}" = "Void Linux" ]; then
    alias \
      po="loginctl poweroff" \
      sp="loginctl suspend" \
      rb="loginctl reboot"
else
    alias \
      po="systemctl poweroff" \
      sp="systemctl suspend" \
      rb="systemctl reboot"
fi

# file management
alias \
  fm="$HOME/.config/vifm/scripts/vifmrun" \
  file="$HOME/.config/vifm/scripts/vifmrun" \
  flm="$HOME/.config/vifm/scripts/vifmrun" \
  vifm="$HOME/.config/vifm/scripts/vifmrun" \
  rm="rm -vI" \
  mv="mv -iv" \
  cp="cp -iv" \
  mkd="mkdir -pv"

# ps
alias \
  psa="ps auxf" \
  psgrep="ps aux | grep -v grep | grep -i -e VSZ -e" \
  psmem="ps auxf | sort -nr -k 4" \
  pscpu="ps auxf | sort -nr -k 3"

# youtube
alias \
  yta-aac="yt-dlp --extract-audio --audio-format aac" \
  yta-best="yt-dlp --extract-audio --audio-format best" \
  yta-flac="yt-dlp --extract-audio --audio-format flac" \
  yta-m4a="yt-dlp --extract-audio --audio-format m4a" \
  yta-mp3="yt-dlp --extract-audio --audio-format mp3" \
  yta-opus="yt-dlp --extract-audio --audio-format opus" \
  yta-vorbis="yt-dlp --extract-audio --audio-format vorbis" \
  yta-wav="yt-dlp --extract-audio --audio-format wav" \
  ytv-best="yt-dlp -f bestvideo+bestaudio" \
  yt="ytfzf -f -t" \
  ytm="ytfzf -m"

# network and bluetooth
alias \
  netstats="nmcli dev" \
  wfi="nmtui-connect" \
  wfi-scan="nmcli dev wifi rescan && nmcli dev wifi list" \
  wfi-edit="nmtui-edit" \
  wfi-on="nmcli radio wifi on" \
  wfi-off="nmcli radio wifi off" \
  blt="bluetoothctl"

### SETTING THE STARSHIP PROMPT ###
eval "$(starship init zsh)"

# Wasienv
export WASIENV_DIR="/home/moss/.wasienv"
[ -s "$WASIENV_DIR/wasienv.sh" ] && source "$WASIENV_DIR/wasienv.sh"

# Wasmer
export WASMER_DIR="/home/moss/.wasmer"
[ -s "$WASMER_DIR/wasmer.sh" ] && source "$WASMER_DIR/wasmer.sh"
