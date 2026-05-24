vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true
vim.opt.cursorline = true

vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = "split"

vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.undofile = true

vim.pack.add({
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/vague-theme/vague.nvim" },
})

vim.cmd.colorscheme("vague")

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local map = function(keys, action, desc)
      vim.keymap.set("n", keys, action, { buffer = event.buf, desc = desc })
    end

    map("K", vim.lsp.buf.hover, "Hover")
    map("gd", vim.lsp.buf.definition, "Definition")
    map("gr", vim.lsp.buf.references, "References")
    map("<leader>rn", vim.lsp.buf.rename, "Rename")
    map("<leader>ca", vim.lsp.buf.code_action, "Code action")
    map("<leader>f", function()
      vim.lsp.buf.format({ async = true })
    end, "Format")
  end,
})

local nix_cmd = function(pkg, bin, ...)
  return { "nix", "shell", "nixpkgs#" .. pkg, "-c", bin, ... }
end

vim.lsp.config("lua_ls", {
  cmd = nix_cmd("lua-language-server", "lua-language-server"),
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      workspace = { checkThirdParty = false },
    },
  },
})

vim.lsp.config("bashls", {
  cmd = nix_cmd("bash-language-server", "bash-language-server", "start"),
})

vim.lsp.config("nil_ls", {
  cmd = nix_cmd("nil", "nil"),
})

vim.lsp.config("pyright", {
  cmd = nix_cmd("pyright", "pyright-langserver", "--stdio"),
})

vim.lsp.config("ts_ls", {
  cmd = nix_cmd("nodePackages.typescript-language-server", "typescript-language-server", "--stdio"),
})

vim.lsp.enable({ "lua_ls", "bashls", "nil_ls", "pyright", "ts_ls" })

vim.keymap.set("n", "<leader>q", "<cmd>quit<cr>", { desc = "Quit" })
vim.keymap.set("n", "<leader>w", "<cmd>write<cr>", { desc = "Write" })
vim.keymap.set("n", "<leader>a", function()
  vim.cmd.write()
  vim.cmd.source("%")
end, { desc = "Apply current file" })
