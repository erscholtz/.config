vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

local function format_with_rustfmt()
  local source = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
  local result = vim.system(
    { "rustfmt", "--emit", "stdout", "--config", "max_width=80" },
    { stdin = source, text = true }
  ):wait()

  if result.code ~= 0 then
    vim.notify(result.stderr, vim.log.levels.ERROR)
    return
  end

  local formatted = result.stdout:gsub("\n$", "")
  local view = vim.fn.winsaveview()
  vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(formatted, "\n", { plain = true }))
  vim.fn.winrestview(view)
end

local function format_current_buffer()
  local clients = vim.lsp.get_clients({
    bufnr = 0,
    method = "textDocument/formatting",
  })

  if #clients > 0 then
    vim.lsp.buf.format({ async = true })
    return
  end

  if vim.bo.filetype == "rust" and vim.fn.executable("rustfmt") == 1 then
    format_with_rustfmt()
    return
  end

  vim.notify("No formatter available for " .. vim.bo.filetype, vim.log.levels.WARN)
end

vim.keymap.set("n", "<leader>lf", format_current_buffer, { desc = "Format" })

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
    map("<leader>lf", format_current_buffer, "Format")
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
      format = {
        defaultConfig = {
          max_line_length = "80",
        },
      },
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
      cargo = {
        allTargets = false,
        buildScripts = {
          enable = false,
        },
      },
      cachePriming = {
        enable = false,
      },
      procMacro = {
        enable = false,
      },
      rustfmt = {
        extraArgs = { "--config", "max_width=80" },
      },
    },
  },
  root_dir = function(bufnr, on_dir)
    local name = vim.api.nvim_buf_get_name(bufnr)
    local root = vim.fs.root(name, { "Cargo.toml", "rust-project.json" })

    if root then
      on_dir(root)
    end
  end,
})

vim.lsp.enable({ "lua_ls", "bashls", "nil_ls", "pyright", "ts_ls", "rust_analyzer" })
