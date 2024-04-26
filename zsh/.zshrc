PROMPT='%F{black}%(?..%K{yellow}  %? )%K{cyan} %~%k%F{cyan}%f '

ZLS_COLORS=''
zmodload -i zsh/complist
autoload -Uz compinit
compinit

# Key bindings
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
alias d='dirs -v' # Lists directory history

# Navigation
setopt autocd
setopt autopushd
setopt pushdsilent
setopt pushdminus
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
zstyle ':completion:*' menu select interactive search
zstyle ':completion:*' verbose true
zstyle ':completion:*:*:*:*:descriptions' format '%F{yellow}-- %d --%f'

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
  elif [[ "$TERM" =~ "screen*" ]]; then print -n "\ek${(%)a}:${(%)2}\e\\"
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

source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh
# Height of fzf window. Selected first
export FZF_DEFAULT_OPTS='--height 20 --reverse --border=sharp --margin=1
 --color=16 
 --color=bg:0,fg:7,hl:3 
 --color=bg+:8,fg+:0,hl+:0 
 --color=gutter:0
 --color=info:3,border:3,prompt:0 
 --color=pointer:0,marker:9,spinner:9,header:1 
'
# Using highlight (http://www.andre-simon.de/doku/highlight/en/highlight.html)
export FZF_CTRL_T_OPTS="--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -100'"
