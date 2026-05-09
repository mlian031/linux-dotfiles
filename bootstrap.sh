#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

info() {
  printf '==> %s\n' "$*"
}

has() {
  command -v "$1" >/dev/null 2>&1
}

install_fedora() {
  local packages=(
    bat
    curl
    direnv
    eza
    fd-find
    fzf
    git
    gnupg2
    lazygit
    neovim
    nodejs
    npm
    cargo
    python3-neovim
    R-core
    ripgrep
    starship
    stow
    tmux
    zathura
    latexmk
    zoxide
    zsh
  )

  info "Installing packages with dnf"
  sudo dnf install -y "${packages[@]}"
}

install_ubuntu() {
  local packages=(
    bat
    curl
    direnv
    fd-find
    fzf
    git
    gnupg
    lazygit
    neovim
    nodejs
    npm
    cargo
    python3-neovim
    r-base
    ripgrep
    stow
    tmux
    zathura
    latexmk
    zoxide
    zsh
  )

  info "Installing packages with apt"
  sudo apt-get update
  sudo apt-get install -y "${packages[@]}"

  if ! has starship; then
    info "Installing starship to ~/.local/bin"
    curl -fsSL https://starship.rs/install.sh | sh -s -- --bin-dir "$HOME/.local/bin" --yes
  fi

  if ! has eza; then
    info "eza is not available from the default apt packages on every Ubuntu release"
    info "Install it from your distribution, cargo, or https://github.com/eza-community/eza"
  fi
}

install_arch() {
  local packages=(
    bat
    curl
    direnv
    eza
    fd
    fzf
    git
    gnupg
    lazygit
    neovim
    nodejs
    npm
    cargo
    python-pynvim
    r
    ripgrep
    starship
    stow
    tmux
    zathura
    texlive-binextra
    zoxide
    zsh
  )

  info "Installing packages with pacman"
  sudo pacman -Syu --needed "${packages[@]}"
}

install_packages() {
  if has dnf; then
    install_fedora
  elif has apt-get; then
    install_ubuntu
  elif has pacman; then
    install_arch
  else
    info "No supported package manager found. Install packages manually, then rerun stow."
  fi
}

install_antidote() {
  if [[ -r "$HOME/.antidote/antidote.zsh" ]]; then
    info "Antidote already installed"
    return
  fi

  info "Installing Antidote"
  git clone --depth=1 https://github.com/mattmc3/antidote.git "$HOME/.antidote"
}

stow_dotfiles() {
  info "Stowing dotfiles"
  stow --dir "$DOTFILES_DIR" --target "$HOME" zsh aliases git nvim
}

main() {
  install_packages
  install_antidote
  stow_dotfiles

  info "Bootstrap complete"
  info "Set zsh as your login shell with: chsh -s \"$(command -v zsh)\""
}

main "$@"
