vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.colorcolumn = "80"

vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.smartindent = true

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = "split"
vim.opt.completeopt = { "menu", "menuone", "noselect" }

vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.undofile = true

vim.pack.add({
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/hrsh7th/nvim-cmp" },
  { src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
  { src = "https://github.com/hrsh7th/cmp-buffer" },
  { src = "https://github.com/hrsh7th/cmp-path" },
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/nvim-telescope/telescope.nvim" },
  { src = "https://github.com/vague-theme/vague.nvim" },
  { src = "https://github.com/stevearc/oil.nvim" },
})

vim.cmd.colorscheme("vague")

require("oil").setup()
require("telescope").setup()
require("config.cmp")
require("config.lsp")
--local harnessd_ok, harnessd = pcall(require, "harnessd")
--if harnessd_ok then
--  harnessd.setup()
--end

vim.keymap.set("n", "<leader>q", "<cmd>quit<cr>", { desc = "Quit" })
vim.keymap.set("n", "<leader>w", "<cmd>write<cr>", { desc = "Write" })
vim.keymap.set("n", "<leader>o", "<cmd>Oil<cr>", { desc = "Open parent directory" })
vim.keymap.set("n", "<leader>e", require("telescope.builtin").find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>a", function()
  vim.cmd.write()
  vim.cmd.source("%")
end, { desc = "Apply current file" })
