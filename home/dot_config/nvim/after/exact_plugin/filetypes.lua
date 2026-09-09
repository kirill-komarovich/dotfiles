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
