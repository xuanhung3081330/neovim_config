require("lspconfig").gopls.setup({ -- Tells Neovim's LSP client to configure and start the gopls server
	capabilities = require("cmp_nvim_lsp").default_capabilities(), -- Makes gopls compatible with nvim-cmp (autocomplete).
	-- It injects "completion capabilities" into the LSP so completion works correctly.

	settings = {
		gopls = {
			gofumpt = true, -- A stricter version of gofmt that enforces additional formatting rules
			formatTool = "goimports",
			analyses = { -- Enables the analysis for unused function parameters. This will show a warning if a function has a parameter that is never used
				unusedparams = true
			}

		}
	}
})

vim.lsp.set_log_level("debug")

vim.api.nvim_create_autocmd("BufWritePre", { -- Sets up an autocommand - a command that runs automatically before the buffer is written (saved)
	buffer = 0 -- Resitrcts the autocommand to only the current buffer (i.e., the Go file currently open)
	callback = function()
		print("Formatting with LSP...")
		vim.lsp.buf.format({ async = false }) -- Tells the LSP (gopls) to format the code synchronously before saving the file.
		-- It fixes indentation, aligns struct tags/types, etc.

})
