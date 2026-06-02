local constants = require("oil.constants")
local columns = require("oil.columns")

local FIELD_NAME = constants.FIELD_NAME
local FIELD_TYPE = constants.FIELD_TYPE

local git_status_cache = {}

local function define_highlights()
  vim.api.nvim_set_hl(0, "OilGitModified", { link = "DiagnosticWarn" })
  vim.api.nvim_set_hl(0, "OilGitUntracked", { link = "DiagnosticInfo" })
  vim.api.nvim_set_hl(0, "OilGitIgnored", { link = "Comment" })
end

define_highlights()
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = define_highlights,
})

local function git_root(path)
  local git_dir = vim.fs.find(".git", { upward = true, path = path })[1]
  if git_dir then
    return vim.fs.dirname(git_dir)
  end
end

local function relpath(path, root)
  local rel = vim.fs.relpath(root, path)
  if not rel or rel == "." then
    return ""
  end
  return rel:gsub("\\", "/") .. "/"
end

local function rank_status(existing, status)
  local rank = {
    ignored = 1,
    modified = 2,
    untracked = 3,
  }

  if not existing or rank[status] > rank[existing] then
    return status
  end
  return existing
end

local function status_kind(code)
  if code == "!!" then
    return "ignored"
  end
  if code == "??" then
    return "untracked"
  end
  if code:find("M", 1, true) then
    return "modified"
  end
end

local function parse_status_output(output)
  local entries = {}
  local fields = vim.split(output or "", "\0", { plain = true, trimempty = true })
  local i = 1

  while i <= #fields do
    local item = fields[i]
    local code = item:sub(1, 2)
    local path = item:sub(4):gsub("\\", "/")
    local kind = status_kind(code)

    if kind and path ~= "" then
      entries[path] = rank_status(entries[path], kind)
    end

    if code:match("[RC]") then
      i = i + 2
    else
      i = i + 1
    end
  end

  return entries
end

local function root_status(root)
  if git_status_cache[root] then
    return git_status_cache[root]
  end

  local result = vim.system({
    "git",
    "status",
    "--ignored",
    "--porcelain=v1",
    "-z",
    "--untracked-files=all",
  }, {
    cwd = root,
    text = true,
  }):wait()

  local status = {}
  if result.code == 0 then
    status = parse_status_output(result.stdout)
  end

  git_status_cache[root] = status
  return status
end

local function entry_status(entry, bufnr)
  local dir = require("oil").get_current_dir(bufnr)
  if not dir or entry[FIELD_NAME] == ".." then
    return nil
  end

  local root = git_root(dir)
  if not root then
    return nil
  end

  local name = entry[FIELD_NAME]:gsub("/$", "")
  local prefix = relpath(dir, root)
  local path = prefix .. name
  local statuses = root_status(root)
  local exact = statuses[path] or statuses[path .. "/"]

  if exact then
    return exact
  end

  if entry[FIELD_TYPE] == "directory" then
    local child_prefix = path .. "/"
    local aggregate

    for changed_path, status in pairs(statuses) do
      if vim.startswith(changed_path, child_prefix) then
        aggregate = rank_status(aggregate, status)
      end
    end

    return aggregate
  end
end

local status_display = {
  modified = { "M", "OilGitModified" },
  untracked = { "?", "OilGitUntracked" },
  ignored = { "!", "OilGitIgnored" },
}

columns.register("git_status", {
  render = function(entry, _, bufnr)
    local status = entry_status(entry, bufnr)
    if status then
      return status_display[status]
    end
    return columns.EMPTY
  end,

  parse = function(line)
    return line:match("^(%S)%s+(.*)$")
  end,
})

local refresh = require("oil.actions").refresh
local original_refresh = refresh.callback
refresh.callback = function(...)
  git_status_cache = {}
  original_refresh(...)
end

require("oil").setup({
  columns = {
    "icon",
    "git_status",
  },
  view_options = {
    is_hidden_file = function(name, bufnr)
      local dir = require("oil").get_current_dir(bufnr)
      local is_dotfile = vim.startswith(name, ".") and name ~= ".."

      if not dir then
        return is_dotfile
      end

      local root = git_root(dir)
      if not root then
        return is_dotfile
      end

      local status = root_status(root)[relpath(dir, root) .. name]
      if status == "ignored" then
        return false
      end

      return is_dotfile
    end,

    highlight_filename = function(entry, _, _, _, bufnr)
      local status = entry_status({
        nil,
        entry.name,
        entry.type,
        entry.meta,
      }, bufnr)

      if status == "modified" then
        return "OilGitModified"
      elseif status == "untracked" then
        return "OilGitUntracked"
      elseif status == "ignored" then
        return "OilGitIgnored"
      end
    end,
  },
})
