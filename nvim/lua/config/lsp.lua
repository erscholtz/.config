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
    map("<leader>lf", function()
      vim.lsp.buf.format({ async = true })
    end, "Format")
  end,
})

local nix_cmd = function(pkg, bin, ...)
  return { "nix", "shell", "nixpkgs#" .. pkg, "-c", bin, ... }
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config("lua_ls", {
  cmd = nix_cmd("lua-language-server", "lua-language-server"),
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      workspace = { checkThirdParty = false },
    },
  },
})

vim.lsp.config("bashls", {
  cmd = nix_cmd("bash-language-server", "bash-language-server", "start"),
  capabilities = capabilities,
})

vim.lsp.config("nil_ls", {
  cmd = nix_cmd("nil", "nil"),
  capabilities = capabilities,
})

vim.lsp.config("pyright", {
  cmd = nix_cmd("pyright", "pyright-langserver", "--stdio"),
  capabilities = capabilities,
})

vim.lsp.config("ts_ls", {
  cmd = nix_cmd("nodePackages.typescript-language-server", "typescript-language-server", "--stdio"),
  capabilities = capabilities,
})

vim.lsp.config("rust_analyzer", {
  cmd = { "rust-analyzer" },
  capabilities = capabilities,
  settings = {
    ["rust-analyzer"] = {
      checkOnSave = false,
      cachePriming = {
        enable = false,
      },
    },
  },
  root_dir = function(bufnr, on_dir)
    local name = vim.api.nvim_buf_get_name(bufnr)
    local root = vim.fs.root(name, { "Cargo.toml", "rust-project.json", ".git" })

    on_dir(root or vim.fs.dirname(name))
  end,
})

vim.lsp.enable({ "lua_ls", "bashls", "nil_ls", "pyright", "ts_ls", "rust_analyzer" })
