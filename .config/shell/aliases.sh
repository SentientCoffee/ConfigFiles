alias sudo="sudo -v ; sudo "

alias cat="bat"
alias chmod="sudo chmod -cR"
alias chown="sudo chown -cR"
alias cls="clear"
alias codium="codium -r"
alias cp="cp -iv"

alias df="df -h"
alias dmesg="sudo dmesg"
alias du="du -h"

alias egrep="grep -E --color=auto"

alias fc-cache="fc-cache -fv"
alias fgrep="grep -F --color=auto"

alias git-dotfiles="git --git-dir=\"${HOME}/.dotfiles\" --work-tree=\"${HOME}\""
alias grep="grep --color=auto"

alias ka="killall -v"

alias lg="lazygit"
alias lg-dotfiles="lazygit -g \"${HOME}/.dotfiles\" -w \"${HOME}\""
alias ll="lsd -Ahl --color=auto --group-directories-first"
alias ln="ln -iv"
alias locate="locate -d ${UPDATEDB_DIR}/plocate.db"
alias ls="lsd -F --color=auto --group-directories-first"

alias mv="mv -iv"
alias mkdir="mkdir -pv"
alias mkinitcpio="sudo mkinitcpio"

alias nft="sudo nft"
alias nvidia-settings="nvidia-settings --config=\"${XDG_CONFIG_HOME}/nvidia/settings\""

# alias reboot="sudo reboot"
alias rm="/bin/rm -iv"
alias rmdir="rmdir -v"
alias rmrf="/bin/rm -rf"

alias shutdown="sudo shutdown now"

alias updatedb="mkdir -p ${UPDATEDB_DIR} ; updatedb -l 0 -o ${UPDATEDB_DIR}/plocate.db"
alias usermod="sudo usermod"

alias winetricks="winetricks -q"

alias xargs-I="xargs -I {} "

alias yarn="yarn --use-yarnrc \"${XDG_CONFIG_HOME}/yarn/config\""

[ -n "${ZSH_VERSION}"  ] && alias refresh="source ${XDG_CONFIG_HOME}/zsh/.zshrc ; rehash ; updatedb"
[ -n "${BASH_VERSION}" ] && alias refresh="source ${HOME}/.bashrc ; updatedb"

mkcd () { mkdir -pv ${1} && cd ${1} || exit 1; }
