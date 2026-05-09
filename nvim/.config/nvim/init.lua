-- ~/.config/nvim/init.lua

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Better provider behavior
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- Core editor settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 400
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.cursorline = true
vim.opt.undofile = true
vim.opt.confirm = true
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.virtualedit = "block"
vim.opt.inccommand = "split"

-- Better writing defaults for prose-heavy files
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown", "quarto", "rmd", "tex", "text" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
		vim.opt_local.spell = true
		vim.opt_local.spelllang = "en_ca,en_us"
	end,
})

-- Quarto / R Markdown filetypes
vim.filetype.add({
	extension = {
		qmd = "quarto",
		rmd = "rmd",
		mdx = "markdown",
	},
	filename = {
		["docker-compose.yml"] = "yaml",
		["docker-compose.yaml"] = "yaml",
	},
})

-- Make current Neovim reachable by nvr for Zathura inverse search
if vim.v.servername == "" then
	pcall(vim.fn.serverstart, vim.fn.stdpath("run") .. "/nvim-server.pipe")
end

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		lazyrepo,
		lazypath,
	})

	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- Theme
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha",
				transparent_background = false,
				integrations = {
					blink_cmp = true,
					gitsigns = true,
					markdown = true,
					mason = true,
					native_lsp = { enabled = true },
					treesitter = true,
					which_key = true,
				},
			})
			vim.cmd.colorscheme("catppuccin")
		end,
	},

	-- One-plugin UI layer: picker, explorer, terminal, lazygit, notifications
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			bigfile = { enabled = true },
			dashboard = { enabled = false },
			explorer = {
				enabled = true,
				replace_netrw = true,
			},
			image = { enabled = true },
			indent = { enabled = true },
			input = { enabled = true },
			lazygit = { enabled = true },
			notifier = { enabled = true },
			picker = { enabled = true },
			quickfile = { enabled = true },
			statuscolumn = { enabled = true },
			terminal = { enabled = true },
			words = { enabled = true },
			zen = { enabled = true },
		},
		config = function(_, opts)
			require("snacks").setup(opts)
			Snacks.input.enable()
			Snacks.picker.setup()
		end,
	},

	-- Icons for which-key / snacks / completion menus
	{
		"nvim-tree/nvim-web-devicons",
		lazy = true,
	},

	-- Keybinding hints
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			preset = "modern",
			delay = 300,
		},
	},

	-- Syntax and structural parsing
	-- IMPORTANT:
	-- You are on Neovim 0.11.6, so use nvim-treesitter's old compatibility branch.
	-- The newer branch expects Neovim 0.12+.
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "master",
		build = ":TSUpdate",
		opts = {
			ensure_installed = {
				"lua",
				"vim",
				"vimdoc",
				"bash",
				"python",
				"r",
				"markdown",
				"markdown_inline",
				"json",
				"yaml",
				"toml",
				"html",
				"css",
				"javascript",
				"regex",
			},
			highlight = { enable = true },
			indent = { enable = true },
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},

	-- Make Markdown/Quarto pleasant inside Neovim
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown", "quarto", "rmd" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {
			file_types = { "markdown", "quarto", "rmd" },
			latex = { enabled = true },
			heading = {
				enabled = true,
				sign = true,
			},
			code = {
				enabled = true,
				sign = false,
				width = "block",
				right_pad = 2,
			},
		},
	},

	-- LSP installer
	{
		"mason-org/mason.nvim",
		opts = {
			ui = {
				border = "rounded",
			},
		},
	},

	-- LSP configs
	{
		"neovim/nvim-lspconfig",
	},

	-- Completion
	{
		"saghen/blink.cmp",
		version = "1.*",
		lazy = false,
		dependencies = {
			"rafamadriz/friendly-snippets",
		},
		opts = {
			keymap = {
				preset = "default",
				["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
				["<C-e>"] = { "hide" },
				["<CR>"] = { "accept", "fallback" },
				["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
				["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
			},
			appearance = {
				nerd_font_variant = "mono",
			},
			completion = {
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 300,
				},
				menu = {
					border = "rounded",
				},
			},
			signature = {
				enabled = true,
				window = {
					border = "rounded",
				},
			},
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},
		},
	},

	-- Connect Mason to native Neovim LSP
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
			"saghen/blink.cmp",
		},
		opts = {
			ensure_installed = {
				"lua_ls",
				"pyright",
				"r_language_server",
				"texlab",
				"marksman",
				"jsonls",
				"yamlls",
				"taplo",
				"bashls",
			},
			automatic_enable = true,
		},
		config = function(_, opts)
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			vim.lsp.config("*", {
				capabilities = capabilities,
			})

			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim", "Snacks" },
						},
						workspace = {
							checkThirdParty = false,
						},
					},
				},
			})

			vim.lsp.config("texlab", {
				settings = {
					texlab = {
						build = {
							executable = "latexmk",
							args = {
								"-pdf",
								"-interaction=nonstopmode",
								"-synctex=1",
								"%f",
							},
							onSave = false,
							forwardSearchAfter = false,
						},
						forwardSearch = {
							executable = "zathura",
							args = {
								"--synctex-forward",
								"%l:1:%f",
								"%p",
							},
						},
					},
				},
			})

			require("mason-lspconfig").setup(opts)
		end,
	},

	-- Ensure non-LSP tools exist too
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = {
			"mason-org/mason.nvim",
		},
		opts = {
			ensure_installed = {
				"stylua",
				"ruff",
				"prettier",
				"latexindent",
			},
			run_on_start = true,
			start_delay = 3000,
		},
	},

	-- Formatting
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		opts = {
			format_on_save = function(bufnr)
				local ft = vim.bo[bufnr].filetype

				-- Auto-format code, but do not auto-format research prose.
				-- LaTeX/Markdown/Quarto formatting can be too aggressive.
				local disabled = {
					tex = true,
					plaintex = true,
					markdown = true,
					quarto = true,
					rmd = true,
				}

				if disabled[ft] then
					return nil
				end

				return {
					timeout_ms = 1000,
					lsp_format = "fallback",
				}
			end,
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "ruff_format" },
				r = { "styler" },
				json = { "prettier" },
				yaml = { "prettier" },
				toml = { "taplo" },
				markdown = { "prettier" },
				quarto = { "prettier" },
				rmd = { "prettier" },
				tex = { "latexindent" },
			},
		},
	},

	-- Git signs in the gutter
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			current_line_blame = false,
		},
	},

	-- LaTeX: compilation, PDF viewing, SyncTeX
	{
		"lervag/vimtex",
		lazy = false,
		init = function()
			vim.g.vimtex_view_method = "zathura"
			vim.g.vimtex_compiler_method = "latexmk"
			vim.g.vimtex_quickfix_mode = 0

			vim.g.vimtex_compiler_latexmk = {
				build_dir = "",
				callback = 1,
				continuous = 1,
				executable = "latexmk",
				options = {
					"-pdf",
					"-verbose",
					"-file-line-error",
					"-synctex=1",
					"-interaction=nonstopmode",
				},
			}
		end,
	},

	-- Quarto support
	{
		"quarto-dev/quarto-nvim",
		ft = { "quarto" },
		dependencies = {
			"jmbuhr/otter.nvim",
			"nvim-treesitter/nvim-treesitter",
			"neovim/nvim-lspconfig",
		},
		opts = {
			lspFeatures = {
				enabled = true,
				languages = { "r", "python", "bash", "lua" },
				chunks = "curly",
				diagnostics = {
					enabled = true,
					triggers = { "BufWritePost" },
				},
				completion = {
					enabled = true,
				},
			},
			codeRunner = {
				enabled = false,
			},
		},
	},

	-- R / R Markdown / Quarto support
	{
		"R-nvim/R.nvim",
		ft = { "r", "rmd", "quarto" },
		opts = {
			R_args = { "--quiet", "--no-save" },
			hook = {
				on_filetype = function()
					vim.keymap.set("n", "<localleader>rf", "<Plug>RStart", { buffer = true, desc = "Start R" })
					vim.keymap.set("n", "<localleader>rr", "<Plug>RSendLine", { buffer = true, desc = "Send R line" })
					vim.keymap.set(
						"v",
						"<localleader>rs",
						"<Plug>RSendSelection",
						{ buffer = true, desc = "Send R selection" }
					)
				end,
			},
		},
	},
	-- AI assistant
	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
		},
		opts = {
			adapters = {
				http = {
					opts = {
						show_model_choices = false,
					},

					qwen_coder_fast = function()
						return require("codecompanion.adapters").extend("ollama", {
							name = "qwen_coder_fast",
							schema = {
								model = {
									default = "qwen-coder-fast",
								},
							},
						})
					end,

					gpt_oss_smart = function()
						return require("codecompanion.adapters").extend("ollama", {
							name = "gpt_oss_smart",
							schema = {
								model = {
									default = "gpt-oss-smart",
								},
							},
						})
					end,
				},
			},

			interactions = {
				-- Default chat uses the smartest local model.
				chat = {
					adapter = "gpt_oss_smart",
				},

				-- Inline edits should stay fast while coding.
				inline = {
					adapter = "qwen_coder_fast",
				},

				-- Command actions should also stay fast.
				cmd = {
					adapter = "qwen_coder_fast",
				},
			},

			display = {
				action_palette = {
					provider = "snacks",
				},
				chat = {
					window = {
						layout = "vertical",
						width = 0.35,
						border = "rounded",
					},
				},
			},

			opts = {
				log_level = "INFO",
			},
		},
	},
}, {
	install = {
		colorscheme = { "catppuccin" },
	},
	checker = {
		enabled = true,
		notify = false,
	},
	change_detection = {
		notify = false,
	},
	rocks = {
		enabled = false,
	},
})

-- LSP keymaps
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(event)
		local map = function(keys, func, desc)
			vim.keymap.set("n", keys, func, {
				buffer = event.buf,
				desc = desc,
			})
		end

		map("gd", vim.lsp.buf.definition, "Go to definition")
		map("gR", vim.lsp.buf.references, "Go to references")
		map("gI", vim.lsp.buf.implementation, "Go to implementation")
		map("K", vim.lsp.buf.hover, "Hover documentation")
		map("<leader>rn", vim.lsp.buf.rename, "Rename")
		map("<leader>ca", vim.lsp.buf.code_action, "Code action")
		map("<leader>fd", vim.diagnostic.open_float, "Line diagnostics")
		map("[d", vim.diagnostic.goto_prev, "Previous diagnostic")
		map("]d", vim.diagnostic.goto_next, "Next diagnostic")
	end,
})

-- General keymaps
local map = vim.keymap.set

map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })
map("n", "<leader>x", "<cmd>q<cr>", { desc = "Close window / quit" })
map("n", "<esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search" })

-- Snacks: VSCode/Cursor-ish workflow
map("n", "<leader>e", function()
	Snacks.picker.explorer()
end, { desc = "File explorer" })

map("n", "<leader><space>", function()
	Snacks.picker.smart()
end, { desc = "Smart picker" })

map("n", "<leader>ff", function()
	Snacks.picker.files()
end, { desc = "Find files" })

map("n", "<leader>fg", function()
	Snacks.picker.grep()
end, { desc = "Live grep" })

map("n", "<leader>fb", function()
	Snacks.picker.buffers()
end, { desc = "Buffers" })

map("n", "<leader>fh", function()
	Snacks.picker.help()
end, { desc = "Help" })

map("n", "<leader>gg", function()
	Snacks.lazygit()
end, { desc = "Lazygit" })

map("n", "<leader>tt", function()
	Snacks.terminal()
end, { desc = "Terminal" })

map("n", "<leader>z", function()
	Snacks.zen()
end, { desc = "Zen mode" })

-- Formatting
map("n", "<leader>F", function()
	require("conform").format({
		async = true,
		lsp_format = "fallback",
	})
end, { desc = "Format file manually" })

-- LaTeX workflow
map("n", "<leader>lc", "<cmd>VimtexCompile<cr>", { desc = "LaTeX compile/watch" })
map("n", "<leader>lv", "<cmd>VimtexView<cr>", { desc = "LaTeX view PDF" })
map("n", "<leader>ls", "<cmd>VimtexStop<cr>", { desc = "LaTeX stop compiler" })
map("n", "<leader>le", "<cmd>VimtexErrors<cr>", { desc = "LaTeX errors" })
map("n", "<leader>lt", "<cmd>VimtexTocToggle<cr>", { desc = "LaTeX TOC" })

-- Quarto / Markdown preview workflow
map("n", "<leader>qp", function()
	local file = vim.fn.expand("%:p")
	Snacks.terminal("quarto preview " .. vim.fn.shellescape(file), {
		win = { position = "bottom" },
	})
end, { desc = "Quarto preview default" })

map("n", "<leader>qP", function()
	local file = vim.fn.expand("%:p")
	Snacks.terminal("quarto preview " .. vim.fn.shellescape(file) .. " --to pdf", {
		win = { position = "bottom" },
	})
end, { desc = "Quarto preview PDF" })

map("n", "<leader>qr", function()
	local file = vim.fn.expand("%:p")
	Snacks.terminal("quarto render " .. vim.fn.shellescape(file), {
		win = { position = "bottom" },
	})
end, { desc = "Quarto render" })

-- AI keymaps
map({ "n", "v" }, "<leader>aa", "<cmd>CodeCompanionActions<cr>", { desc = "AI actions" })
map({ "n", "v" }, "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "AI chat" })
map("v", "<leader>ai", ":CodeCompanion ", { desc = "AI inline prompt" })

map("n", "<leader>aq", function()
	vim.cmd("CodeCompanionChat Toggle")
	vim.notify("AI chat opened. Default chat model: gpt-oss-smart", vim.log.levels.INFO)
end, { desc = "AI chat smart model" })

map("n", "<leader>as", function()
	Snacks.terminal("ollama run gpt-oss-smart", {
		win = { position = "bottom" },
	})
end, { desc = "Run smart model in terminal" })

map("n", "<leader>af", function()
	Snacks.terminal("ollama run qwen-coder-fast", {
		win = { position = "bottom" },
	})
end, { desc = "Run fast model in terminal" })

map("n", "<leader>ap", function()
	Snacks.terminal("ollama ps", {
		win = { position = "bottom" },
	})
end, { desc = "Show Ollama running models" })

map("n", "<leader>aS", function()
	Snacks.terminal("ollama stop qwen-coder-fast; ollama stop gpt-oss-smart", {
		win = { position = "bottom" },
	})
end, { desc = "Stop Ollama models" })

-- Maple italic inside Neovim code/syntax groups only.
-- Ghostty should stay Regular; Neovim requests italics through highlights.
local function set_italic(group)
	local ok, hl = pcall(vim.api.nvim_get_hl, 0, {
		name = group,
		link = false,
	})

	if not ok then
		return
	end

	hl.italic = true
	vim.api.nvim_set_hl(0, group, hl)
end

local function italicize_code_groups()
	local groups = {
		"Comment",
		"String",
		"Character",
		"Number",
		"Boolean",
		"Float",
		"Identifier",
		"Function",
		"Statement",
		"Conditional",
		"Repeat",
		"Operator",
		"Keyword",
		"Type",
		"Special",

		"@variable",
		"@variable.builtin",
		"@constant",
		"@constant.builtin",
		"@string",
		"@character",
		"@number",
		"@boolean",
		"@float",
		"@function",
		"@function.builtin",
		"@function.call",
		"@function.method",
		"@keyword",
		"@keyword.function",
		"@keyword.return",
		"@conditional",
		"@repeat",
		"@operator",
		"@type",
		"@type.builtin",
		"@property",
		"@field",
		"@parameter",
		"@comment",
	}

	for _, group in ipairs(groups) do
		set_italic(group)
	end
end

vim.api.nvim_create_autocmd({ "VimEnter", "ColorScheme" }, {
	callback = italicize_code_groups,
})
