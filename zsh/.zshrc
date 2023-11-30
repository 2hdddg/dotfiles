PROMPT='%F{black}%(?..%K{yellow}  %? )%K{cyan} %~%k%F{cyan}%f '
zmodload -i zsh/complist
autoload -Uz compinit
compinit
ZLS_COLORS=''

# Key bindings
#bindkey -M menuselect 'h' vi-backward-char
#bindkey -M menuselect 'k' vi-up-line-or-history
#bindkey -M menuselect 'j' vi-down-line-or-history
#bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect ' ' history-incremental-search-forward
# Auto completion using arrow keys (based on history). Terminal specific
# Detect with ctrl+v up/down
bindkey '^[[A' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward

# Aliases
alias ls='ls --color=auto'
alias l='ls -al --color=auto'
alias grep='grep --color=auto'
alias s='git status -sb'

# Navigation
setopt autocd
setopt autopushd

# Misc
setopt no_beep

# Completion
# Disables prompt to show completions
LISTPROMPT=''
# Shows menu at first tab
setopt MENU_COMPLETE
setopt AUTO_LIST
setopt COMPLETE_IN_WORD
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _extensions _complete _ignored _approximate
# Detailed file list when completing files
zstyle ':completion:*'  file-list all
zstyle ':completion:*:default' list-colors '=*=90'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select
zstyle ':completion:*' verbose true

# History
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt hist_ignore_all_dups
setopt append_history
setopt inc_append_history
setopt share_history
autoload -U +X bashcompinit && bashcompinit





#
# Update terminal/tmux window titles based on location/command

function update_title() {
  local a
  # escape '%' in $1, make nonprintables visible
  a=${(V)1//\%/\%\%}
  print -nz "%20>...>$a"
  read -rz a
  # remove newlines
  a=${a//$'\n'/}
  if [[ -n "$TMUX" ]] && [[ $TERM == screen* || $TERM == tmux* ]]; then
    print -n "\ek${(%)a}:${(%)2}\e\\"
  elif [[ "$TERM" =~ "screen*" ]]; then
    print -n "\ek${(%)a}:${(%)2}\e\\"
  elif [[ "$TERM" =~ "xterm*" || "$TERM" =~ "alacritty|wezterm" || "$TERM" =~ "st*" ]]; then
    print -n "\e]0;${(%)a}:${(%)2}\a"
  elif [[ "$TERM" =~ "^rxvt-unicode.*" ]]; then
    printf '\33]2;%s:%s\007' ${(%)a} ${(%)2}
  fi
}

# called just before the prompt is printed
function _zsh_title__precmd() {
  update_title "zsh" "%20<...<%~"
}

# called just before a command is executed
function _zsh_title__preexec() {
  local -a cmd
  
  # Escape '\'
  1=${1//\\/\\\\\\\\}

  cmd=(${(z)1})             # Re-parse the command line

  # Construct a command that will output the desired job number.
  case $cmd[1] in
    fg)	cmd="${(z)jobtexts[${(Q)cmd[2]:-%+}]}" ;;
    %*)	cmd="${(z)jobtexts[${(Q)cmd[1]:-%+}]}" ;;
  esac
  update_title "$cmd" "%20<...<%~"
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd _zsh_title__precmd
add-zsh-hook preexec _zsh_title__preexec

