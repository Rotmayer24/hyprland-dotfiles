vim.pack.add({
	"https://github.com/folke/edgy.nvim",
	"https://github.com/stevearc/oil.nvim",
	"https://github.com/windwp/nvim-ts-autotag",
	"https://github.com/echasnovski/mini.surround",
	"https://github.com/folke/persistence.nvim",
	"https://github.com/lewis6991/gitsigns.nvim",

	"https://github.com/catppuccin/nvim",
	"https://github.com/rose-pine/neovim",
	"https://github.com/ellisonleao/gruvbox.nvim",
	"https://github.com/rebelot/kanagawa.nvim",
	"https://github.com/navarasu/onedark.nvim",
	"https://github.com/Mofiqul/dracula.nvim",

	"https://github.com/folke/tokyonight.nvim",
	"https://github.com/nvim-tree/nvim-tree.lua",
	"https://github.com/folke/which-key.nvim",
	"https://github.com/kdheepak/lazygit.nvim",
	"https://github.com/akinsho/toggleterm.nvim",

	{ src = "https://github.com/mason-org/mason.nvim.git" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim.git" },
	{ src = "https://github.com/neovim/nvim-lspconfig.git" },

	"https://github.com/L3MON4D3/LuaSnip",
	"https://github.com/rafamadriz/friendly-snippets",

	"https://github.com/akinsho/nvim-bufferline.lua",
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/Saghen/blink.cmp",

	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/nvim-telescope/telescope.nvim",

	"https://github.com/MunifTanjim/nui.nvim",
	"https://github.com/rcarriga/nvim-notify",
	"https://github.com/folke/noice.nvim",
	"https://github.com/numToStr/Comment.nvim",
	"https://github.com/lukas-reineke/indent-blankline.nvim",
	"https://github.com/folke/todo-comments.nvim",
	"https://github.com/Nvchad/nvim-colorizer.lua",
	"https://github.com/monkoose/neocodeium",
	"https://github.com/rachartier/tiny-cmdline.nvim",

	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/folke/flash.nvim",
	"https://github.com/stevearc/conform.nvim",

	"https://github.com/folke/lsp-colors.nvim",
	"https://github.com/onsails/lspkind.nvim",
	"https://github.com/folke/neodev.nvim",

	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/goolord/alpha-nvim",
	"https://github.com/alex-popov-tech/store.nvim",
	"https://github.com/hmdfrds/focal.nvim",
	"https://github.com/molleweide/LuaSnip-snippets.nvim",
})

require("tokyonight").setup({
	transparent = true,
	styles = {
		sidebars = "transparent",
		floats = "transparent",
	},
})
vim.cmd.colorscheme("tokyonight")
require("neodev").setup()
require("lsp-colors").setup()

require("nvim-tree").setup({
	disable_netrw = true,
	hijack_netrw = true,
	view = { width = 35, side = "left" },
	update_focused_file = { enable = true, update_root = true },
	actions = {
		open_file = { quit_on_open = false, resize_window = true },
	},
	renderer = {
		group_empty = true,
		highlight_git = true,
		icons = { show = { git = true, file = true, folder = true, folder_arrow = true } },
	},
	filters = { dotfiles = false },
})

local function toggle_nvimtree_focus()
	local api = require("nvim-tree.api")
	if vim.bo.filetype == "NvimTree" then
		vim.cmd("wincmd p")
	else
		api.tree.open()
		api.tree.focus()
		api.tree.find_file({ open = true, focus = true })
	end
end

vim.keymap.set(
	"n",
	"<C-h>",
	toggle_nvimtree_focus,
	{ desc = "Toggle focus between NvimTree and editor", silent = true }
)
vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle NvimTree" })

require("which-key").setup({ preset = "modern" })

require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = {
		"lua_ls",
		"basedpyright",
		"pyright",
		"rust_analyzer",
		"emmet_ls",
		"eslint",
		"ts_ls",
		"tailwindcss",
	},
})

local on_attach = function(client, bufnr)
	local opts = { noremap = true, silent = true, buffer = bufnr }

	opts.desc = "LSP: Code actions"
	vim.keymap.set("n", "<leader>ca", function()
		vim.lsp.buf.code_action({
			filter = function(a)
				return not a.disabled
			end,
		})
	end, opts)

	opts.desc = "LSP: Go to definition"
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)

	opts.desc = "LSP: Hover documentation"
	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

	opts.desc = "LSP: Rename symbol"
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

	opts.desc = "LSP: Format document"
	vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, opts)

	opts.desc = "LSP: Show diagnostic float"
	vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)

	opts.desc = "LSP: Previous diagnostic"
	vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

	opts.desc = "LSP: Next diagnostic"
	vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
end

vim.lsp.config("basedpyright", { on_attach = on_attach })
vim.lsp.config("pyright", { on_attach = on_attach })
vim.lsp.config("rust_analyzer", { on_attach = on_attach })
vim.lsp.config("ts_ls", { on_attach = on_attach })
vim.lsp.config("eslint", { on_attach = on_attach })
vim.lsp.config("tailwindcss", { on_attach = on_attach })
vim.lsp.config("lua_ls", { on_attach = on_attach })
vim.lsp.config("emmet_ls", {
	on_attach = on_attach,
	filetypes = { "html", "htmldjango", "djangohtml" },
})

require("bufferline").setup({
	options = {
		mode = "buffers",
		separator_style = "thin",
		diagnostics = "nvim_lsp",
		always_show_bufferline = true,
		offsets = {
			{ filetype = "NvimTree", text = "File Explorer", text_align = "center", separator = true },
		},
	},
})

vim.keymap.set("n", "H", "<cmd>BufferLineCyclePrev<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "L", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "x", "<cmd>bprevious | bdelete #<CR>", { desc = "Close current buffer", silent = true })

require("blink.cmp").setup({
	keymap = {
		preset = "default",
		["<Tab>"] = { "select_next", "fallback" },
		["<S-Tab>"] = { "select_prev", "fallback" },
		["<CR>"] = { "accept", "fallback" },
		["<C-e>"] = { "cancel" },
		["<C-y>"] = { "accept" },
	},
	appearance = {
		nerd_font_variant = "mono",
		use_nvim_cmp_as_default = true,
	},
	completion = {
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 250,
			window = { border = "rounded" },
		},
		list = {
			selection = {
				preselect = true,
				auto_insert = false,
			},
		},
		menu = {
			auto_show = true,
			border = "rounded",
			draw = {
				columns = { { "kind_icon" }, { "label", gap = 1 }, { "kind" } },
			},
		},
	},
	signature = {
		enabled = true,
		window = { border = "rounded" },
	},
	fuzzy = {
		implementation = "prefer_rust",
		use_frecency = true,
		use_proximity = true,
	},
	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
	},
})

local builtin = require("telescope.builtin")
require("telescope").setup({})

vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "Search current word" })
vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "Search diagnostics" })
vim.keymap.set("n", "gb", ":Telescope buffers<CR>", { desc = "Switch buffer" })

local function SearchClasses()
	builtin.lsp_dynamic_workspace_symbols({ symbols = { "Class" }, prompt_title = "Search Classes" })
end
local function SearchFunctions()
	builtin.lsp_dynamic_workspace_symbols({ symbols = { "Function", "Method" }, prompt_title = "Search Functions" })
end
local function SearchVariables()
	builtin.lsp_dynamic_workspace_symbols({ symbols = { "Variable", "Constant" }, prompt_title = "Search Variables" })
end

vim.keymap.set("n", "<leader>sf", SearchFunctions, { desc = "Telescope: Search functions" })
vim.keymap.set("n", "<leader>sc", SearchClasses, { desc = "Telescope: Search classes" })
vim.keymap.set("n", "<leader>sv", SearchVariables, { desc = "Telescope: Search variables" })
vim.keymap.set("n", "<leader>ss", builtin.lsp_dynamic_workspace_symbols, { desc = "Telescope: Search all symbols" })
vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "Telescope: Search help tags" })
vim.keymap.set("n", "<leader>sq", builtin.quickfix, { desc = "Telescope: Show quickfix list" })
vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "Telescope: Search keymaps" })
vim.keymap.set("n", "<C-e>", builtin.oldfiles, { desc = "Telescope: Recent files" })

require("store").setup()
require("focal").setup()
require("Comment").setup()

require("noice").setup({
	lsp = {
		override = {
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			["vim.lsp.util.stylize_markdown"] = true,
			["cmp.entry.get_documentation"] = true,
		},
	},
	presets = {
		bottom_search = true,
		command_palette = true,
		long_message_to_split = true,
		lsp_doc_border = true,
	},
})

require("nvim-treesitter").setup({
	ensure_installed = { "lua", "python", "rust", "javascript", "typescript", "html", "css", "json", "markdown" },
	highlight = { enable = true },
	indent = { enable = true },
})

require("ibl").setup({
	indent = { char = "▏" },
	scope = { enabled = true, show_start = false, show_end = false },
	exclude = { filetypes = { "NvimTree", "dashboard", "help", "mason", "alpha" } },
})

require("todo-comments").setup({})
require("flash").setup({})
require("lualine").setup({ options = { theme = "tokyonight" } })
require("colorizer").setup()
require("gitsigns").setup()
require("tiny-cmdline").setup()

require("neocodeium").setup({
	manual = false,
	debounce = false,
})

vim.keymap.set("i", "<A-f>", function()
	require("neocodeium").accept()
end, { desc = "NeoCodeium: Accept suggestion" })
vim.keymap.set("i", "<A-w>", function()
	require("neocodeium").accept_word()
end, { desc = "NeoCodeium: Accept word" })
vim.keymap.set("i", "<A-e>", function()
	require("neocodeium").cycle_or_complete()
end, { desc = "NeoCodeium: Cycle or trigger suggestion" })
vim.keymap.set("i", "<A-c>", function()
	require("neocodeium").clear()
end, { desc = "NeoCodeium: Clear suggestion" })

require("luasnip").setup({
	enable_autosnippets = true,
	store_selection_keys = "<CR>",
})

require("luasnip.loaders.from_vscode").lazy_load()

vim.keymap.set("i", "<CR>", function()
	if require("luasnip").expandable() then
		require("luasnip").expand()
		return ""
	else
		return "<CR>"
	end
end, { expr = true, desc = "Expand snippet or new line" })

local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

dashboard.section.header.val = {
	"                                                       ",
	"   ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗  ",
	"   ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║  ",
	"   ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║  ",
	"   ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║  ",
	"   ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║  ",
	"   ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝  ",
	"                                                       ",
}

dashboard.section.buttons.val = {
	dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
	dashboard.button("f", "  Find file", ":Telescope find_files<CR>"),
	dashboard.button("r", "  Recent files", ":Telescope oldfiles<CR>"),
	dashboard.button("c", "  Settings", ":e $MYVIMRC<CR>"),
	dashboard.button("q", "󰈆  Quit NVIM", ":qa<CR>"),
}

alpha.setup(dashboard.config)
vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])

vim.g.conform_enabled = true

function ToggleConform()
	vim.g.conform_enabled = not vim.g.conform_enabled
	local status = vim.g.conform_enabled and "ON" or "OFF"
	vim.notify("Conform formatting: " .. status, "info", { title = "Conform" })
end

vim.keymap.set("n", "<leader>ct", ToggleConform, { desc = "Toggle Conform formatting" })

require("conform").setup({
	formatters_by_ft = {
		python = { "black" },
		javascript = { "prettier" },
		typescript = { "prettier" },
		javascriptreact = { "prettier" },
		typescriptreact = { "prettier" },
		html = { "prettier" },
		css = { "prettier" },
		yaml = { "prettier" },
		markdown = { "prettier" },
		json = { "prettier" },
		lua = { "stylua" },
	},
	format_on_save = function(bufnr)
		if vim.g.conform_enabled then
			return { timeout_ms = 500, lsp_fallback = true }
		end
		return false
	end,
})

require("toggleterm").setup({
	size = 20,
	open_mapping = [[<c-\>]],
	hide_numbers = true,
	shade_filetypes = {},
	shade_terminals = true,
	shading_factor = 1,
	start_in_insert = true,
	insert_mappings = false,
	persist_size = true,
	direction = "float",
	close_on_exit = true,
	shell = vim.o.shell,
	float_opts = {
		border = "rounded",
		width = 100,
		height = 20,
		winblend = 0,
	},
})

vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm<CR>", { desc = "Toggle terminal" })
vim.keymap.set("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", { desc = "Terminal horizontal" })
vim.keymap.set("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<CR>", { desc = "Terminal vertical" })

vim.keymap.set("n", "<leader>lg", "<cmd>LazyGit<CR>", { desc = "Open Lazygit" })

require("oil").setup({
	default_view = "split",
	columns = { "icon" },
	keymaps = {
		["<CR>"] = "actions.select",
		["-"] = "actions.parent",
	},
})
vim.keymap.set("n", "-", "<cmd>Oil<CR>", { desc = "Open parent directory" })

require("lspkind").init({
	mode = "symbol_text",
	preset = "codicons",
})

require("edgy").setup({
	left = { { title = "NvimTree", ft = "NvimTree" } },
	bottom = {},
	options = {
		integrate = {
			["toggleterm"] = false,
		},
	},
})

require("mini.surround").setup()
require("persistence").setup()

vim.keymap.set("n", "<leader>w", "<cmd>write<CR>", { desc = "Save file" })
vim.keymap.set("n", "<leader>q", "<cmd>bd<CR>", { desc = "Close buffer" })

local themes = {
	"tokyonight",
	"onedark",
	"dracula",
	"catppuccin",
	"rose-pine",
	"gruvbox",
	"kanagawa",
	"habamax",
	"elflord",
	"oxocarbon",
}

local current_theme_index = 1

function SetTheme(theme_name)
	vim.cmd.colorscheme("default")

	if theme_name == "tokyonight" then
		require("tokyonight").setup({
			transparent = true,
			styles = { sidebars = "transparent", floats = "transparent" },
		})
		vim.cmd.colorscheme("tokyonight")
	elseif theme_name == "onedark" then
		pcall(function()
			require("onedark").setup({
				transparent = true,
				style = "darker",
			})
			vim.cmd.colorscheme("onedark")
		end)
	elseif theme_name == "dracula" then
		pcall(function()
			require("dracula").setup({
				transparent_bg = true,
				show_end_of_buffer = true,
				italic_comment = true,
			})
			vim.cmd.colorscheme("dracula")
		end)
	elseif theme_name == "catppuccin" then
		pcall(function()
			require("catppuccin").setup({
				transparent_background = true,
				flavour = "mocha",
			})
			vim.cmd.colorscheme("catppuccin")
		end)
	elseif theme_name == "rose-pine" then
		pcall(function()
			require("rose-pine").setup({
				disable_background = true,
				styles = { transparency = true },
			})
			vim.cmd.colorscheme("rose-pine")
		end)
	elseif theme_name == "gruvbox" then
		pcall(function()
			require("gruvbox").setup({
				transparent_mode = true,
			})
			vim.cmd.colorscheme("gruvbox")
		end)
	elseif theme_name == "kanagawa" then
		pcall(function()
			require("kanagawa").setup({
				transparent = true,
			})
			vim.cmd.colorscheme("kanagawa")
		end)
	else
		vim.cmd.colorscheme(theme_name)
	end

	vim.notify("Theme changed to: " .. theme_name, "info", { title = "Theme" })
end

local function theme_picker()
	local theme_list = {}
	for _, theme in ipairs(themes) do
		table.insert(theme_list, theme)
	end

	require("telescope.pickers")
		.new({}, {
			prompt_title = "Select Theme",
			finder = require("telescope.finders").new_table({
				results = theme_list,
			}),
			sorter = require("telescope.config").values.generic_sorter({}),
			attach_mappings = function(_, map)
				map("i", "<CR>", function(prompt_bufnr)
					local selection = require("telescope.actions.state").get_selected_entry()
					require("telescope.actions").close(prompt_bufnr)
					SetTheme(selection[1])
				end)
				return true
			end,
		})
		:find()
end

require("notify").setup({
	stages = "fade",
	fps = 60,
	timeout = 3000,
	background_colour = "#000000",
})

vim.api.nvim_set_hl(0, "NotifyBackground", { bg = "#000000" })

vim.keymap.set("n", "<leader>to", theme_picker, { desc = "Theme picker (Telescope)" })

vim.api.nvim_create_user_command("Theme", function(opts)
	if opts.args == "" then
		print("Available themes: " .. table.concat(themes, ", "))
	else
		SetTheme(opts.args)
	end
end, {
	nargs = "?",
	complete = function()
		return themes
	end,
})

require("lualine").setup({
	options = {
		theme = "tokyonight",
		section_separators = { left = "", right = "" },
		component_separators = { left = "", right = "" },
	},
	sections = {
		lualine_x = {
			{
				function()
					return "󰨋 " .. (vim.g.colors_name or "unknown")
				end,
				color = { gui = "bold" },
			},
			"filetype",
		},
	},
})

vim.api.nvim_create_autocmd("BufWritePost", {
	callback = function()
		vim.diagnostic.show()
	end,
})
