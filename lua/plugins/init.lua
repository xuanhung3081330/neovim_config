-- Load all plugins with Lazy.nvim

vim.opt.number = true -- Show absolute line numbers (on the current line)
vim.opt.relativenumber = false -- Show relative line numbers (on all other lines - useful for jumping, like 5k, 3j)
vim.opt.cursorline = true -- Highlight the current line
vim.opt.signcolumn = "yes" -- Always show the sign column
vim.opt.numberwidth = 5
vim.cmd("syntax on") -- Enables basic syntax highlighting for all filetypes.


return require("lazy").setup({

  -- LSP and completion
  { 
	  "neovim/nvim-lspconfig", -- Plugin for easy configuration of language servers (LSP)
	  event = { "BufReadPre", "BufNewFile" }, -- Lazy-load the plugin only when you open a file (for performance)
	  config = function() -- Define a configuration function that runs after the plugin loads
		  local lspconfig = require("lspconfig") -- Load the lspconfig module which provides access to LSP setups

		  lspconfig.gopls.setup({ -- Configure the Go language server (gopls)
			  capabilities = require("cmp_nvim_lsp").default_capabilities(),
			  -- This line enhances the LSP capabilities (e.g., completion support)
		  })
	  end,
  },         -- Core LSP configuration
  { 
	  "hrsh7th/nvim-cmp",
	  dependencies = {
		"hrsh7th/cmp-nvim-lsp", -- LSP source for nvim-cmp - Provides language server-based completions (e.g., variables, functions, types from Go, Python, etc.)
		"hrsh7th/cmp-buffer" , -- buffer words - For ex, if you typed 'database' earlier, and then type 'dat', it will suggest 'database'
		"hrsh7th/cmp-path", -- file paths - File path completion
		"hrsh7th/cmp-cmdline", -- command line completions
		"L3MON4D3/LuaSnip", -- snippet engine - Complete snippet (like typing func in Go, it will output the template)
		--"saadparwaíz/cmp_luasnip", -- LuaSnip source for cmp - Connect nvim-cmp and LuaSnip
	  },
	  config = function()
		  local cmp = require("cmp") -- Load the nvim-cmp plugin
		  cmp.setup({
			  snippet = { -- #1/ tells nvim-cmp how to expand a snippet when selecting it from autocomplete,
				  expand = function(args)
					  require("luasnip").lsp_expand(args.body) -- #2/ Uses LuaSnip as the snippet engine. #3/ args.body contains the snippet template
				  end,
			  },
			  mapping = cmp.mapping.preset.insert({ -- Defines key mappings for interacting with the completion popup.
				  ["<Tab>"] = cmp.mapping.select_next_item(), -- Go to the next suggestion
				  ["<S-Tab>"] = cmp.mapping.select_prev_item(), -- Go to the previous suggestion
				  ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Confirm the selection
				  ["<C-Space>"] = cmp.mapping.complete(), -- Manually trigger completion popup
			  }),
			  sources = cmp.config.sources({ -- This defines where nvim-cmp gets its suggestions from
				  { name = "nvim_lsp" },
				  { name = "luasnip" },
			  },{
				  { name = "buffer" },
				  { name = "path" },
			  }),
		  })
	  end,

  },              -- Autocompletion engine

  -- Treesitter for syntax highlighting and parsing
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  -- YAML and Kubernetes schema support
  { "b0o/schemastore.nvim" },          -- Provides schemas for YAML
  -- { "jubnzv/validaty.nvim" },          -- Schema-based YAML validation

  -- Dockerfile syntax highlighting
  { "ekalinin/Dockerfile.vim" },

  -- UI/UX tools
  { "nvim-telescope/telescope.nvim", tag = "0.1.0" }, -- Fuzzy finder
  { "nvim-lualine/lualine.nvim" },     -- Status line
  { 
	  "kyazdani42/nvim-tree.lua",
	  dependencies = { "nvim-tree/nvim-web-devicons" },
	  config = function()
		  require("nvim-tree").setup({
			  filters = {
				  dotfiles = false,
				  custom = {}, -- Clear anything that might hide files like ".env"
			  },
			  git = {
				  enable = true,
				  ignore = false, -- Don't hide files ignored by .gitignore
			  }
		  })
	  end,
  },      -- File explorer
  { 
	  "windwp/nvim-autopairs", -- PLugin to get from get GitHub
	  event = "InsertEnter", -- Tells Lazy.nvim to lazy-load the plugin when we enter Insert mode
	  config = function()
		  require("nvim-autopairs").setup({}) -- Initializes the plugin with default settings. You can pass options inside {} if you want custom behavior
	  end,
  },
  {
	  "folke/tokyonight.nvim",
	  lazy = false, -- Load this plugin immediately at startup rather than delaying it.
	  priority = 1000, -- Plugins are loaded in order of highest to lowest priority. A high number like 1000 ensures this plugin loads before others, which is useful when you're applying a color scheme and want it to override any other UI styles or plugin themes.
	  config = function()
		  vim.cmd("colorscheme tokyonight")
	  end,
  }
})
