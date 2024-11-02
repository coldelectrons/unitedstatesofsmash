--[[
`lvim` is the global options object

Linters should be
filled in as strings with either
a global executable or a path to
an executable
]]

-- vim options
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.relativenumber = true
vim.g.conceallevel = 1

-- general
lvim.log.level = "warn"
lvim.format_on_save = {
	enabled = true,
	pattern = "*.lua",
	timeout = 1000,
}
-- lvim.lsp.diagnostic.config({ virtual_text = true })
vim.diagnostic.config({ virtual_text = true })
-- to disable icons and use a minimalist setup, uncomment the following
-- lvim.use_icons = false
vim.g.use_nerd_icons = true

-- keymappings <https://www.lunarvim.org/docs/configuration/keybindings>
lvim.leader = "space"
-- add your own keymapping
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.keys.normal_mode["<C-ScrollWheelUp>"] = ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>"
lvim.keys.normal_mode["<C-ScrollWheelDown>"] = ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>"
lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"

-- -- Use which-key to add extra bindings with the leader-key prefix
lvim.builtin.which_key.mappings["W"] = { "<cmd>noautocmd w<cr>", "Save without formatting" }
lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
lvim.builtin.which_key.mappings["S"] = {
	name = "+Spectre",
	S = { "<cmd>lua require('spectre').toggle()<CR>", "Toggle Spectre" },
	w = { "<cmd>lua require('spectre').open_visual({select_word=true})<CR>", "Search current word" },
	W = { "<cmd>lua require('spectre').open_visual()<CR>", "Search current word" },
	F = { "<cmd>lua require('spectre').open_file_search({select_word=true})<CR>", "Search on current file" },
}
lvim.builtin.which_key.mappings["t"] = {
	name = "+Trouble",
	t = { "<cmd>TroubleToggle<cr>", "trouble" },
	r = { "<cmd>TroubleToggle lsp_references<cr>", "References" },
	f = { "<cmd>TroubleToggle lsp_definitions<cr>", "Definitions" },
	d = { "<cmd>TroubleToggle document_diagnostics<cr>", "Diagnostics" },
	q = { "<cmd>TroubleToggle quickfix<cr>", "QuickFix" },
	l = { "<cmd>TroubleToggle loclist<cr>", "LocationList" },
	w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Workspace Diagnostics" },
}
lvim.builtin.which_key.mappings["z"] = {
	name = "+Telekasten",
	f = { "<cmd>Telekasten find_notes<cr>", "find notes" },
	t = { "<cmd>ZkTags { excludeHrefs = { 'node_modules' } }<cr>", "find tags" },
	d = { "<cmd>Telekasten find_daily_notes<cr>", "find daily notes" },
	g = { "<cmd>Telekasten search_notes<cr>", "search notes" },
	z = { "<cmd>Telekasten follow_link<cr>", "follow link" },
	T = { "<cmd>Telekasten goto_today<cr>", "go to note for today" },
	W = { "<cmd>Telekasten goto_thisweek<cr>", "go to note for this week" },
	w = { "<cmd>Telekasten find_weekly_notes<cr>", "find weekly notes" },
	n = { "<cmd>Telekasten new_note<cr>", "new note" },
	N = { "<cmd>Telekasten new_templated_note<cr>", "new templated note" },
	y = { "<cmd>Telekasten yank_notelink<cr>", "yank notelink" },
	c = { "<cmd>Telekasten show_calendar<cr>", "show calendar" },
	C = { "<cmd>CalendarT<cr>", "SHOW CALENDAR" },
	i = { "<cmd>Telekasten paste_img_and_link<cr>", "paste image and link from clipboard" },
	t = { "<cmd>Telekasten toggle_todo<cr>", "toggle todo" },
	b = { "<cmd>Telekasten show_backlinks<cr>", "show backlinks" },
	F = { "<cmd>Telekasten find_friends<cr>", "find friends" },
	I = { "<cmd>Telekasten insert_img_link<cr>", "insert image link" },
	p = { "<cmd>Telekasten preview_img<cr>", "preview image" },
	m = { "<cmd>Telekasten browse_media<cr>", "browse media" },
	s = { "<cmd>Telekasten show_tags<cr>", "show tags" },
	v = { "<cmd>Telekasten switch_vault<cr>", "switch vault" },
	Z = { "<cmd>Telekasten panel<cr>", "command palette panel" },
}
-- lvim.builtin.which_key.mappings["z"] = {
--   f = "<cmd>ZkNotes { excludeHrefs = { 'node_modules' } }<cr>", "find notes"},
--   t = "<cmd>ZkTags { excludeHrefs = { 'node_modules' } }<cr>", "find tags"},
--   n = "<cmd>ZkNew({title = '' })<LEFT><LEFT><LEFT><LEFT>", "new note"},
--   e = "<cmd>'<,'>ZkNewFromTitleSelection<cr>", "new note from selection"},
-- }
--

lvim.keys.normal_mode["s"] = ":HopChar2<cr>"
lvim.keys.normal_mode["S"] = ":HopChar1<cr>"
lvim.builtin.which_key.mappings["H"] = {
	name = "+Hop",
	-- f = { "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>", "hop after cursor on current line" },
	-- F = { "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>", "hop before cursor on current line" },
	-- t = { "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })<cr>", "hop after cursor on current line" },
	-- T = { "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })<cr>", "hop before cursor on current line" },
	w = { "<cmd>lua require'hop'.HopWord<cr>", "hop to word" },
	l = { "<cmd>lua require'hop'.HopLine<cr>", "hop to line" },
	L = { "<cmd>lua require'hop'.HopLineStart<cr>", "hop to line start" },
}

lvim.keys.normal_mode["<S-A-Up>"] = ":GUIFontSizeUp<cr>"
lvim.keys.normal_mode["<S-A-Down>"] = ":GUIFontSizeDown<cr>"
-- -- Change theme settings
lvim.colorscheme = "tokyodark"

lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false

-- Automatically install missing parsers when entering buffer
lvim.builtin.treesitter.auto_install = true

-- lvim.builtin.treesitter.ignore_install = { "haskell" }

-- -- always installed on startup, useful for parsers without a strict filetype
lvim.builtin.treesitter.ensure_installed = { "comment", "markdown_inline", "regex", "python", "lua", "nix" }

-- -- generic LSP settings <https://www.lunarvim.org/docs/languages#lsp-support>

-- --- disable automatic installation of servers
-- lvim.lsp.installer.setup.automatic_installation = false

-- ---configure a server manually. IMPORTANT: Requires `:LvimCacheReset` to take effect
-- ---see the full default list `:lua =lvim.lsp.automatic_configuration.skipped_servers`
-- vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "pyright" })
-- local opts = {} -- check the lspconfig documentation for a list of all possible options
-- require("lvim.lsp.manager").setup("pyright", opts)

-- ---remove a server from the skipped list, e.g. eslint, or emmet_ls. IMPORTANT: Requires `:LvimCacheReset` to take effect
-- ---`:LvimInfo` lists which server(s) are skipped for the current filetype
-- lvim.lsp.automatic_configuration.skipped_servers = vim.tbl_filter(function(server)
--   return server ~= "emmet_ls"
-- end, lvim.lsp.automatic_configuration.skipped_servers)

-- -- you can set a custom on_attach function that will be used for all the language servers
-- -- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end

-- -- linters and formatters <https://www.lunarvim.org/docs/languages#lintingformatting>
local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup({
	{ command = "stylua" },
	{ name = "black" },
	--   {
	--     command = "prettier",
	--     extra_args = { "--print-width", "100" },
	--     filetypes = { "typescript", "typescriptreact" },
	--   },
})
local linters = require("lvim.lsp.null-ls.linters")
linters.setup({
	{ command = "flake8", args = { "--ignore=E203" }, filetypes = { "python" } },
	--   {
	--     command = "shellcheck",
	--     args = { "--severity", "warning" },
	--   },
})

-- -- Additional Plugins <https://www.lunarvim.org/docs/plugins#user-plugins>
lvim.plugins = {
	{ "folke/tokyonight.nvim" },
	{ "tiagovla/tokyodark.nvim" },
	{ "EdenEast/nightfox.nvim" },
	{ "catppuccin/nvim", lazy = true, name = "catppuccin", priority = 1000 },
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	-- misc little things
	{ "pbrisbin/vim-mkdir" },
	-- And so it goes, I hear motion
	{
		"smoka7/hop.nvim",
		version = "*", -- optional but strongly recommended
		config = function()
			-- you can configure Hop the way you like here; see :h hop-config
			require("hop").setup()
		end,
	},
	-- the obligatory writing mode
	{
		"folke/zen-mode.nvim",
		config = function()
			require("zen-mode").setup({
				window = {
					backdrop = 0.95, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
					-- height and width can be:
					-- * an absolute number of cells when > 1
					-- * a percentage of the width / height of the editor when <= 1
					-- * a function that returns the width or the height
					width = 120, -- width of the Zen window
					height = 1, -- height of the Zen window
					-- by default, no options are changed for the Zen window
					-- uncomment any of the options below, or add other vim.wo options you want to apply
					options = {
						-- signcolumn = "no", -- disable signcolumn
						-- number = false, -- disable number column
						-- relativenumber = false, -- disable relative numbers
						-- cursorline = false, -- disable cursorline
						-- cursorcolumn = false, -- disable cursor column
						-- foldcolumn = "0", -- disable fold column
						-- list = false, -- disable whitespace characters
					},
				},
				plugins = {
					-- disable some global vim options (vim.o...)
					-- comment the lines to not apply the options
					options = {
						enabled = true,
						ruler = false, -- disables the ruler text in the cmd line area
						showcmd = false, -- disables the command in the last line of the screen
					},
					twilight = { enabled = true }, -- enable to start Twilight when zen mode opens
					gitsigns = { enabled = false }, -- disables git signs
					tmux = { enabled = false }, -- disables the tmux statusline
					-- this will change the font size on kitty when in zen mode
					-- to make this work, you need to set the following kitty options:
					-- - allow_remote_control socket-only
					-- - listen_on unix:/tmp/kitty
					kitty = {
						enabled = true,
						font = "+4", -- font size increment
					},
				},
				-- callback where you can add custom code when the Zen window opens
				on_open = function(win) end,
				-- callback where you can add custom code when the Zen window closes
				on_close = function() end,
			})
		end,
	},
	{ "renerocksai/calendar-vim" },
	{ "nvim-telescope/telescope-media-files.nvim" },
	{ "nvim-telescope/telescope-symbols.nvim" },
	{
		"renerocksai/telekasten.nvim",
		dependencies = {
			"nvim-lua/popup.nvim", -- already in lunarvim
			"nvim-lua/plenary.nvim", -- already in lunarvim
			"nvim-telescope/telescope.nvim",
			"nvim-telescope/telescope-media-files.nvim",
			"renerocksai/calendar-vim",
			"nvim-telescope/telescope-symbols.nvim",
			"ekickx/clipboard-image.nvim",
		},
	},
	{
		"zk-org/zk-nvim",
		config = function()
			require("zk").setup({
				picker = "telescope",
			})
		end,
	},
	{
		"kevinhwang91/nvim-bqf",
		event = { "BufRead", "BufNew" },
		config = function()
			require("bqf").setup({
				auto_enable = true,
				preview = {
					win_height = 12,
					win_vheight = 12,
					delay_syntax = 80,
					border_chars = { "┃", "┃", "━", "━", "┏", "┓", "┗", "┛", "█" },
				},
				func_map = {
					vsplit = "",
					ptogglemode = "z,",
					stoggleup = "",
				},
				filter = {
					fzf = {
						action_for = { ["ctrl-s"] = "split" },
						extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
					},
				},
			})
		end,
	},
	{
		"windwp/nvim-spectre",
		event = "BufRead",
		config = function()
			require("spectre").setup()
		end,
	},
	{
		"kevinhwang91/rnvimr",
		cmd = "RnvimrToggle",
		config = function()
			vim.g.rnvimr_draw_border = 1
			vim.g.rnvimr_pick_enable = 1
			vim.g.rnvimr_bw_enable = 1
		end,
	},
	{
		"camspiers/snap",
		config = function()
			local snap = require("snap")
			local layout = snap.get("layout").bottom
			local file = snap.config.file:with({ consumer = "fzf", layout = layout })
			local vimgrep = snap.config.vimgrep:with({ layout = layout })
			snap.register.command("find_files", file({ producer = "ripgrep.file" }))
			snap.register.command("buffers", file({ producer = "vim.buffer" }))
			snap.register.command("oldfiles", file({ producer = "vim.oldfile" }))
			snap.register.command("live_grep", vimgrep({}))
		end,
	},
	{
		"andymass/vim-matchup",
		event = "CursorMoved",
		config = function()
			vim.g.matchup_matchparen_offscreen = { method = "popup" }
		end,
	},
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		event = "BufRead",
	},
	-- {
	--     "p00f/nvim-ts-rainbow",
	-- },
	{
		"nvim-treesitter/playground",
		event = "BufRead",
	},
	{
		"romgrk/nvim-treesitter-context",
		config = function()
			require("treesitter-context").setup({
				enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
				throttle = true, -- Throttles plugin updates (may improve performance)
				max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
				patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
					-- For all filetypes
					-- Note that setting an entry here replaces all other patterns for this entry.
					-- By setting the 'default' entry below, you can control which nodes you want to
					-- appear in the context window.
					default = {
						"class",
						"function",
						"method",
					},
				},
			})
		end,
	},
	{
		"nvim-telescope/telescope-project.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
		event = "BufWinEnter",
		-- setup = function()
		-- vim.cmd [[packadd telescope.nvim]]
		-- end,
	},
	-- { "Vigemus/iron.nvim" },
	-- { "akinsho/toggleterm.nvim", version = "*", config = true },
	-- { "voldikss/vim-floaterm" },
	-- {
	-- 	"jghauser/kitty-runner.nvim",
	-- 	config = function()
	-- 		require("kitty-runner").setup()
	-- 	end,
	-- },
	{
		"kdheepak/lazygit.nvim",
		-- optional for floating window border decoration
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},
	"stevearc/dressing.nvim",
	"ellisonleao/glow.nvim",
	"ktunprasert/gui-font-resize.nvim",
	-- {
	--     "tris203/precognition.nvim",
	--     --event = "VeryLazy",
	--     opts = {
	--     -- startVisible = true,
	--     -- showBlankVirtLine = true,
	--     -- highlightColor = { link = "Comment" },
	--     -- hints = {
	--     --      Caret = { text = "^", prio = 2 },
	--     --      Dollar = { text = "$", prio = 1 },
	--     --      MatchingPair = { text = "%", prio = 5 },
	--     --      Zero = { text = "0", prio = 1 },
	--     --      w = { text = "w", prio = 10 },
	--     --      b = { text = "b", prio = 9 },
	--     --      e = { text = "e", prio = 8 },
	--     --      W = { text = "W", prio = 7 },
	--     --      B = { text = "B", prio = 6 },
	--     --      E = { text = "E", prio = 5 },
	--     -- },
	--     -- gutterHints = {
	--     --     G = { text = "G", prio = 10 },
	--     --     gg = { text = "gg", prio = 9 },
	--     --     PrevParagraph = { text = "{", prio = 8 },
	--     --     NextParagraph = { text = "}", prio = 8 },
	--     -- },
	--     },
	-- },
	-- {
	--   "m4xshen/hardtime",
	--   dependencies = {"MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
	--   opts = {}
	-- },
}

require("gui-font-resize").setup({ default_size = 10, change_by = 1, bounds = { maximum = 20 } })

local opts = { noremap = true, silent = true }

local home = vim.fn.expand("~/Sync/zk") -- have to manually make the folder
-- local home = require('plenary.path'):new("~/zettelkasten"):normalize()
-- local home = '/home/thomas/zettelkasten'
require("telekasten").setup({
	home = home,
	-- if true, telekasten will be enabled when opening a note within the configured home
	take_over_my_home = true,
	-- auto-set telekasten filetype: if false, the telekasten filetype will not be used
	--                               and thus the telekasten syntax will not be loaded either
	auto_set_filetype = true,
	-- dir names for special notes (absolute path or subdir name)
	dailies = home .. "/" .. "daily",
	weeklies = home .. "/" .. "weekly",
	templates = home .. "/" .. "templates",
	-- image (sub)dir for pasting
	-- dir name (absolute path or subdir name)
	-- or nil if pasted images shouldn't go into a special subdir
	image_subdir = "img",
	-- markdown file extension
	extension = ".md",
	-- Generate note filenames. One of:
	-- "title" (default) - Use title if supplied, uuid otherwise
	-- "uuid" - Use uuid
	-- "uuid-title" - Prefix title by uuid
	-- "title-uuid" - Suffix title with uuid
	new_note_filename = "title",
	-- file uuid type ("rand" or input for os.date()")
	uuid_type = "%Y%m%d%H%M",
	-- UUID separator
	uuid_sep = "-",
	-- following a link to a non-existing note will create it
	follow_creates_nonexisting = true,
	dailies_create_nonexisting = true,
	weeklies_create_nonexisting = true,
	-- skip telescope prompt for goto_today and goto_thisweek
	journal_auto_open = false,
	-- template for new notes (new_note, follow_link)
	-- set to `nil` or do not specify if you do not want a template
	template_new_note = home .. "/" .. "templates/new_note.md",
	-- template for newly created daily notes (goto_today)
	-- set to `nil` or do not specify if you do not want a template
	template_new_daily = home .. "/" .. "templates/daily.md",
	-- template for newly created weekly notes (goto_thisweek)
	-- set to `nil` or do not specify if you do not want a template
	template_new_weekly = home .. "/" .. "templates/weekly.md",
	-- image link style
	-- wiki:     ![[image name]]
	-- markdown: ![](image_subdir/xxxxx.png)
	image_link_style = "markdown",
	-- default sort option: 'filename', 'modified'
	sort = "filename",
	-- integrate with calendar-vim
	plug_into_calendar = true,
	calendar_opts = {
		-- calendar week display mode: 1 .. 'WK01', 2 .. 'WK 1', 3 .. 'KW01', 4 .. 'KW 1', 5 .. '1'
		weeknm = 4,
		-- use monday as first day of week: 1 .. true, 0 .. false
		calendar_monday = 1,
		-- calendar mark: where to put mark for marked days: 'left', 'right', 'left-fit'
		calendar_mark = "left-fit",
	},

	-- telescope actions behavior
	close_after_yanking = false,
	insert_after_inserting = true,

	-- tag notation: '#tag', ':tag:', 'yaml-bare'
	tag_notation = "#tag",

	-- command palette theme: dropdown (window) or ivy (bottom panel)
	command_palette_theme = "ivy",

	-- tag list theme:
	-- get_cursor: small tag list at cursor; ivy and dropdown like above
	show_tags_theme = "ivy",

	-- when linking to a note in subdir/, create a [[subdir/title]] link
	-- instead of a [[title only]] link
	subdirs_in_links = true,

	-- template_handling
	-- What to do when creating a new note via `new_note()` or `follow_link()`
	-- to a non-existing note
	-- - prefer_new_note: use `new_note` template
	-- - smart: if day or week is detected in title, use daily / weekly templates (default)
	-- - always_ask: always ask before creating a note
	template_handling = "smart",

	-- path handling:
	--   this applies to:
	--     - new_note()
	--     - new_templated_note()
	--     - follow_link() to non-existing note
	--
	--   it does NOT apply to:
	--     - goto_today()
	--     - goto_thisweek()
	--
	--   Valid options:
	--     - smart: put daily-looking notes in daily, weekly-looking ones in weekly,
	--              all other ones in home, except for notes/with/subdirs/in/title.
	--              (default)
	--
	--     - prefer_home: put all notes in home except for goto_today(), goto_thisweek()
	--                    except for notes with subdirs/in/title.
	--
	--     - same_as_current: put all new notes in the dir of the current note if
	--                        present or else in home
	--                        except for notes/with/subdirs/in/title.
	new_note_location = "smart",

	-- should all links be updated when a file is renamed
	rename_update_links = true,
})

-- -- Autocommands (`:help autocmd`) <https://neovim.io/doc/user/autocmd.html>
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "zsh",
--   callback = function()
--     -- let treesitter use bash highlight for zsh files as well
--     require("nvim-treesitter.highlight").attach(0, "bash")
--   end,
-- })
