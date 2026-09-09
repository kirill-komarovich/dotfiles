-- chezmoi names a source file after its target plus .tmpl, so the useful
-- filetype is whatever the target would get. Rewriting the whole path, not
-- just the name: source prefixes hide the leading dot that name matching needs
-- for files like .tmux.conf, and types like ghostty are matched by directory.
local prefixes = { "dot_", "private_", "readonly_", "executable_", "symlink_", "encrypted_", "empty_" }

local function strip(segment)
  local changed = true
  while changed do
    changed = false
    for _, prefix in ipairs(prefixes) do
      if segment:sub(1, #prefix) == prefix then
        segment = (prefix == "dot_" and "." or "") .. segment:sub(#prefix + 1)
        changed = true
        break
      end
    end
  end
  return segment
end

local function target_path(path)
  local out = {}
  for segment in vim.gsplit(path:gsub("%.tmpl$", ""), "/", { plain = true }) do
    table.insert(out, strip(segment))
  end
  return table.concat(out, "/")
end

vim.filetype.add({
  pattern = {
    -- Neither nvim nor treesitter knows ghostty, whose config is key = value.
    [".*/ghostty/config"] = "ini",

    [".*%.tmpl"] = function(path, bufnr)
      return vim.filetype.match({ filename = target_path(path), buf = bufnr })
    end,
  },
})

-- Highlighting both layers takes a flavour of the gotmpl grammar per host
-- language: the same parser registered under another name, whose queries can
-- name the host statically the way heex names elixir. Injecting the other way
-- round fails because a host parser shreds {{ ... }} into fragments too small
-- to parse.
local flavours = {
  toml = "toml", fish = "fish", sh = "bash", bash = "bash", lua = "lua",
  ini = "ini", json = "json", yaml = "yaml", tmux = "tmux", markdown = "markdown",
}

local gotmpl_so = vim.api.nvim_get_runtime_file("parser/gotmpl.so", false)[1]
local registered = {}

local function flavour_for(filetype)
  local host = flavours[filetype]
  if not host or not gotmpl_so then
    return nil
  end

  local lang = "gotmpl_" .. host
  if not registered[lang] then
    local ok = pcall(vim.treesitter.language.add, lang, { path = gotmpl_so, symbol_name = "gotmpl" })
    if not ok then
      return nil
    end
    registered[lang] = true
  end

  return lang
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  group = vim.api.nvim_create_augroup("chezmoi-template-highlight", { clear = true }),
  callback = function(args)
    if not vim.api.nvim_buf_get_name(args.buf):match("%.tmpl$") then
      return
    end

    local lang = flavour_for(vim.bo[args.buf].filetype)
    if lang then
      vim.treesitter.stop(args.buf)
      vim.treesitter.start(args.buf, lang)
    end
  end,
})
