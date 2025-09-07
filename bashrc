#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto -1'
alias grep='grep --color=auto'

alias la='ls -a'

alias timer='tty-countdown'

alias vencord='sh -c "$(curl -sS https://raw.githubusercontent.com/Vendicated/VencordInstaller/main/install.sh)"'

# PS1=' \[\e[1;31m\]\w\[\e[m\] \[\e[0;31m\]| \[\e[m\]'
PROMPT_COMMAND='
  branch=$(git branch --show-current 2>/dev/null)
  if [ -n "$branch" ]; then
    git_part=" \[\e[38;5;150m\]git:(\[\e[38;5;198m\]$branch\[\e[38;5;150m\])"
  else
    git_part=""
  fi
  PS1="\[\e[38;5;210;1m\] \W$git_part \[\e[38;5;210m\]  \[\e[0m\]"
'

PATH="$PATH":"$HOME/.local/scripts/"
bind '"\C-f":"tmux-sessionizer\n"'

#wallpaper
wp() {
  local file
  file=$(find ~/pictures/wallpapers -type f -not -path '*/.*' -printf "%T@ %p\n" 2> /dev/null | sort -nr | cut -d' ' -f2- | fzf)
  if [[ -n "$file" ]]; then
    pkill wbg 2> /dev/null
    nohup wbg "$file" > /dev/null 2>&1 &
  fi
}

# fuzzy finder
cdf() {
  local dir
  dir=$(find ~/ -type d 2> /dev/null | fzf) && cd "$dir"
}

vim() {
    local path
    path=$(find ~/ 2> /dev/null | fzf) && nvim "$path"
}

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
