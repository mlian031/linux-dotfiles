# Dotfiles

Small Linux-first (might extend this to macos later, but that's not anytime soon) dotfiles managed with GNU Stow.

## Setup

Clone the repo into home directory:

```sh
git clone git@github.com:mikeliang/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

Run the bootstrap script:

```sh
./bootstrap.sh
```

The script installs the expected CLI tools, installs Antidote if needed, and stows the `zsh`, `aliases`, `git`, and `nvim` packages into `$HOME`.

Set zsh as the login shell if it is not already:

```sh
chsh -s "$(command -v zsh)"
```

Restart the terminal after the first setup.

## Manual Stow

To link the current packages without installing tools:

```sh
stow zsh aliases git nvim
```

To preview changes:

```sh
stow --simulate zsh aliases git nvim
```

Optional machine-local settings can go in `~/.zshrc.local` or `~/.aliases.local`. Those files are not managed by this repo.

## Neovim

The Neovim package tracks `~/.config/nvim/init.lua` and `~/.config/nvim/lazy-lock.json`.

Do not commit generated runtime state such as `~/.local/share/nvim`, Mason package installs, Lazy plugin checkouts, swap files, or caches. On a new machine, open Neovim and run `:Lazy sync`; Mason-managed language servers and formatters are declared in the config.

CodeCompanion is configured to use local Ollama models:

- `gpt-oss-smart` for chat
- `qwen-coder-fast` for inline edits and command actions

Ollama itself is machine-local. Install and start Ollama separately, then make sure those model names exist before using the AI keymaps.
