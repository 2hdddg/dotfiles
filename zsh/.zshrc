PROMPT='%F{black}%(?..%K{yellow}%?)%K{cyan} %~%k%F{cyan}%f '

zmodload -i zsh/complist
autoload -Uz compinit
compinit
ZLS_COLORS=''

# Key bindings
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'l' vi-forward-char
# Auto completion using arrow keys (based on history). Terminal specific
bindkey '^[OA' history-beginning-search-backward
bindkey '^[OB' history-beginning-search-forward

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
