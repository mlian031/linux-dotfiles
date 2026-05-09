# Neovim Cheatsheet

`<leader>` is `Space`. `<localleader>` is `\`.

## Daily Keys

| Key | Action |
| --- | --- |
| `<leader>w` | Save |
| `<leader>x` | Close window / quit |
| `<Esc>` | Clear search highlight |
| `<leader>e` | File explorer |
| `<leader><Space>` | Smart picker |
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Buffers |
| `<leader>fh` | Help |
| `<leader>gg` | Lazygit |
| `<leader>tt` | Terminal |
| `<leader>z` | Zen mode |

## Code

| Key | Action |
| --- | --- |
| `gd` | Go to definition |
| `gR` | References |
| `gI` | Implementation |
| `K` | Hover docs |
| `<leader>rn` | Rename |
| `<leader>ca` | Code action |
| `<leader>fd` | Line diagnostics |
| `[d` | Previous diagnostic |
| `]d` | Next diagnostic |
| `<leader>F` | Format file |

## LaTeX

| Key | Action |
| --- | --- |
| `<leader>lc` | Compile / watch |
| `<leader>lv` | View PDF |
| `<leader>ls` | Stop compiler |
| `<leader>le` | Errors |
| `<leader>lt` | Table of contents |

## Quarto

| Key | Action |
| --- | --- |
| `<leader>qp` | Preview |
| `<leader>qP` | Preview PDF |
| `<leader>qr` | Render |

## R

| Key | Action |
| --- | --- |
| `<localleader>rf` | Start R |
| `<localleader>rr` | Send R line |
| `<localleader>rs` | Send R selection |

## AI

| Key | Action |
| --- | --- |
| `<leader>aa` | AI actions |
| `<leader>ac` | AI chat |
| `<leader>ai` | AI inline prompt, visual mode |
| `<leader>aq` | AI chat, smart model |
| `<leader>as` | Run `gpt-oss-smart` |
| `<leader>af` | Run `qwen-coder-fast` |
| `<leader>ap` | Show Ollama running models |
| `<leader>aS` | Stop Ollama models |

## Copyable Commands

Open Neovim:

```sh
nvim .
```

Update plugins:

```vim
:Lazy sync
```

Open Mason:

```vim
:Mason
```

Check health:

```vim
:checkhealth
```

Check formatting setup:

```vim
:ConformInfo
```

LaTeX commands:

```vim
:VimtexCompile
:VimtexView
:VimtexErrors
:VimtexStop
```

Quarto commands:

```sh
quarto preview file.qmd
quarto preview file.qmd --to pdf
quarto render file.qmd
```

Ollama commands:

```sh
ollama ps
ollama run gpt-oss-smart
ollama run qwen-coder-fast
ollama stop gpt-oss-smart
ollama stop qwen-coder-fast
```
