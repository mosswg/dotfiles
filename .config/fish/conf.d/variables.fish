set -gx PATH ~/.local/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/usr/share/games:/usr/local/sbin:/usr/sbin:/sbin:/usr/local/texlive/2022/bin/x86_64-linux:~/.emacs.d/bin:$PATH
set -gx JDK_HOME /usr/lib/jvm/openjdk17
set -gx PICO_SDK_PATH /home/moss/documents/coding/gitclones/pico-sdk
set -gx GPG_TTY $(tty)
set -gx TERM "xterm-256color"                      # getting proper colors
set -gx HISTCONTROL ignoredups:erasedups           # no duplicate entries
set -gx PYENV_ROOT "$HOME/.pyenv"
