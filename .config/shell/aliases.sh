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

alias ga="git add -v"
alias gA="git add -Av"
alias gAc="git add -Av && git commit"
alias gc="git commit"
alias gcP="git commit && git push"
alias gd="git diff"
alias git-dotfiles="git --git-dir=\"${HOME}/.dotfiles\" --work-tree=\"${HOME}\""
alias gl="git log --color=always --graph --date=format:'%a %b %d %G %H:%M' --decorate --pretty=format:'%C(yellow)%h %C(green)%ad %Creset%s %C(red)%d %C(cyan)[%an]%Creset'"
alias gM="git merge"
alias gp="git pull"
alias gpR="git pull --rebase"
alias gP="git push"
alias gr="git restore"
alias grep="grep --color=auto"
alias grs="git restore --staged"
alias gs="git status"

alias ka="killall -v"

alias lg="lazygit"
alias ll="lsd -Ahl --color=auto --group-directories-first"
alias ln="ln -iv"
alias locate="locate -d ${UPDATEDB_DIR}/locate.db"
alias ls="lsd -F --color=auto --group-directories-first"

alias mv="mv -iv"
alias mkdir="mkdir -pv"
alias mkinitcpio="sudo mkinitcpio"

alias nft="sudo nft"
alias nvidia-settings="nvidia-settings --config=\"${XDG_CONFIG_HOME}/nvidia/settings\""

# alias reboot="sudo reboot"
alias rm="rm -iv"
alias rmdir="rmdir -v"

alias shutdown="sudo shutdown now"

alias updatedb="mkdir -p ${UPDATEDB_DIR} ; updatedb --output=${UPDATEDB_DIR}/locate.db"
alias usermod="sudo usermod"

alias winetricks="winetricks -q"

alias xargs-I="xargs -I {} "

alias yarn="yarn --use-yarnrc \"${XDG_CONFIG_HOME}/yarn/config\""

[ -n "${ZSH_VERSION}"  ] && alias refresh="source ${XDG_CONFIG_HOME}/zsh/.zshrc ; rehash ; updatedb"
[ -n "${BASH_VERSION}" ] && alias refresh="source ${HOME}/.bashrc ; updatedb"
