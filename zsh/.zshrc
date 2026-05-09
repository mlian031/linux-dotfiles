
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/mikeliang/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# paths
export PATH="$HOME/.local/bin:$PATH"
export EDITOR="nvim"
export VISUAL="code --wait"

# history
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt appendhistory sharehistory hist_ignore_dups hist_reduce_blanks
setopt autocd correct interactivecomments

# antidote
source "$HOME/.antidote/antidote.zsh"
antidote load "$HOME/.zsh_plugins.txt"

# prompt
eval "$(starship init zsh)"

# direnv
eval "$(direnv hook zsh)"

# local aliases
[ -f "$HOME/.aliases" ] && source "$HOME/.aliases"
export GPG_TTY=$(tty)
