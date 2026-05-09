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

The script installs the expected CLI tools, installs Antidote if needed, and stows the `zsh`, `aliases`, and `git` packages into `$HOME`.

Set zsh as the login shell if it is not already:

```sh
chsh -s "$(command -v zsh)"
```

Restart the terminal after the first setup.

## Manual Stow

To link the current packages without installing tools:

```sh
stow zsh aliases git
```

To preview changes:

```sh
stow --simulate zsh aliases git
```

Optional machine-local settings can go in `~/.zshrc.local` or `~/.aliases.local`. Those files are not managed by this repo.
