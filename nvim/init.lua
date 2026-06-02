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
  { src = "https://github.com/windwp/nvim-autopairs" },
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/nvim-telescope/telescope.nvim" },
  { src = "https://github.com/vague-theme/vague.nvim" },
  { src = "https://github.com/stevearc/oil.nvim" },
})

require("vague").setup({
  transparent = true,
})

vim.cmd.colorscheme("vague")

local function keep_terminal_background()
  for _, group in ipairs({
    "Normal",
    "NormalNC",
    "NormalFloat",
    "SignColumn",
    "EndOfBuffer",
    "LineNr",
    "FoldColumn",
  }) do
    vim.api.nvim_set_hl(0, group, { bg = "NONE" })
  end
end

keep_terminal_background()
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = keep_terminal_background,
})

local function color_todo_keywords_like_strings()
  vim.api.nvim_set_hl(0, "TodoStringKeyword", { link = "String" })
  vim.api.nvim_set_hl(0, "Todo", { link = "String" })
end

local function match_todo_keywords()
  if vim.w.todo_string_keyword_match_id then
    pcall(vim.fn.matchdelete, vim.w.todo_string_keyword_match_id)
  end

  vim.w.todo_string_keyword_match_id =
    vim.fn.matchadd("TodoStringKeyword", [[\<\(NOTE\|FIXME\|FIX\|TODO\)\>]])
end

color_todo_keywords_like_strings()
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = color_todo_keywords_like_strings,
})

vim.api.nvim_create_autocmd({ "VimEnter", "WinEnter", "BufWinEnter" }, {
  callback = match_todo_keywords,
})

require("config.oil")
require("telescope").setup()
require("config.cmp")
require("config.autopairs")
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
