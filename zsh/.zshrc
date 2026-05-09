
# paths
export PATH="$HOME/.local/bin:$PATH"
export EDITOR="${EDITOR:-nvim}"
export VISUAL="${VISUAL:-code --wait}"

# history
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt append_history
setopt share_history
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt hist_find_no_dups

# shell behavior
bindkey -v
setopt auto_cd
setopt interactive_comments
setopt no_beep

# completion
autoload -Uz compinit
compinit -d "$HOME/.zcompdump"
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu no

# plugins
if [[ -r "$HOME/.antidote/antidote.zsh" ]]; then
  source "$HOME/.antidote/antidote.zsh"
  antidote load "$HOME/.zsh_plugins.txt"
fi

# fzf
if command -v fzf >/dev/null 2>&1 && [[ -t 0 && -t 1 ]]; then
  if command -v fd >/dev/null 2>&1; then
    _fzf_fd=fd
  elif command -v fdfind >/dev/null 2>&1; then
    _fzf_fd=fdfind
  fi

  if [[ -n "${_fzf_fd:-}" ]]; then
    export FZF_DEFAULT_COMMAND="$_fzf_fd --type f --hidden --follow --exclude .git"
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND="$_fzf_fd --type d --hidden --follow --exclude .git"
  fi

  if command -v bat >/dev/null 2>&1; then
    _fzf_bat=bat
  elif command -v batcat >/dev/null 2>&1; then
    _fzf_bat=batcat
  fi

  if [[ -n "${_fzf_bat:-}" ]]; then
    export FZF_CTRL_T_OPTS="--preview \"$_fzf_bat --style=numbers --color=always --line-range :200 {} 2>/dev/null\""
  fi

  source <(fzf --zsh)
  unset _fzf_fd _fzf_bat
fi

# prompt and shell integrations
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"
command -v direnv >/dev/null 2>&1 && eval "$(direnv hook zsh)"
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"

# local config
[[ -r "$HOME/.aliases" ]] && source "$HOME/.aliases"
[[ -r "$HOME/.aliases.local" ]] && source "$HOME/.aliases.local"
[[ -r "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

export GPG_TTY="$(tty)"
