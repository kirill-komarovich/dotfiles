-- Native insert-mode completion, replacing nvim-cmp and its sources.

vim.opt.shortmess:append("c")

-- Pops the menu on every keystroke rather than only on the server's
-- triggerCharacters, which is what made this viable to leave cmp for.
-- Always set through vim.go: 'autocomplete' is global-local, and plain
-- `vim.o` would also write the buffer-local value, overwriting the opt-out
-- that prompt buffers below rely on.
vim.go.autocomplete = true

--   .  current buffer   w  other windows   b  listed buffers
--   o  omnifunc (vim.lsp.omnifunc, set on LSP attach)
--   F  completefunc (the path source below)
-- ^N caps a source so buffer words cannot crowd out LSP results.
vim.o.complete = ".^5,w^5,b^5,o,F"
vim.o.completefunc = "v:lua.kk_path_complete"
vim.o.completeopt = "menu,menuone,popup,fuzzy,noselect"
vim.o.autocompletedelay = 0

-- There is no minimum-prefix option, and servers return items for an empty
-- leader, so the menu would open on blank lines and after every space.
-- "." and ":" stay in the set so `vim.` still completes members.
vim.api.nvim_create_autocmd("InsertCharPre", {
  group = vim.api.nvim_create_augroup("kk_completion_gate", { clear = true }),
  callback = function()
    vim.go.autocomplete = vim.v.char:match("[%w_.:/~$-]") ~= nil
  end,
})

-- Telescope's prompt is an ordinary insert-mode buffer, so a global
-- 'autocomplete' pops a completion menu over the picker. Same for any other
-- prompt buffer (vim.ui.input and friends).
vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
  group = vim.api.nvim_create_augroup("kk_completion_prompts", { clear = true }),
  callback = function(ev)
    if vim.bo[ev.buf].buftype == "prompt" or vim.bo[ev.buf].filetype == "TelescopePrompt" then
      vim.bo[ev.buf].autocomplete = false
    end
  end,
})

local kind_icons = {
  Text = "󰉿", Method = "󰆧", Function = "󰊕", Constructor = "",
  Field = "󰜢", Variable = "󰀫", Class = "󰠱", Interface = "",
  Module = "", Property = "󰜢", Unit = "󰑭", Value = "󰎠",
  Enum = "", Keyword = "󰌋", Snippet = "", Color = "󰏘",
  File = "󰈙", Reference = "󰈇", Folder = "󰉋", EnumMember = "",
  Constant = "󰏿", Struct = "󰙅", Event = "", Operator = "󰆕",
  TypeParameter = "",
}

-- The server label cannot come from the 'convert' below: that is stored once
-- per buffer, by whichever client attaches first, so a closure over its name
-- would label every server's items with that one name. The client id is only
-- known a layer up, where each client's results are converted, so the label is
-- stamped on there.
local convert_results = vim.lsp.completion._convert_results
if convert_results then
  vim.lsp.completion._convert_results = function(line, lnum, cursor_col, client_id, ...)
    local matches, server_start_boundary = convert_results(line, lnum, cursor_col, client_id, ...)
    local client = vim.lsp.get_client_by_id(client_id)
    if client then
      for _, match in ipairs(matches) do
        match.menu = "[" .. client.name .. "]"
      end
    end
    return matches, server_start_boundary
  end
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("kk_completion_lsp", { clear = true }),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client or not client:supports_method("textDocument/completion") then
      return
    end

    -- Required even though 'autocomplete' does the triggering: this is what
    -- applies snippets, import edits and the resolved docs popup on accept.
    vim.lsp.completion.enable(true, ev.data.client_id, ev.buf, {
      convert = function(item)
        local kind = vim.lsp.protocol.CompletionItemKind[item.kind] or "Text"
        return { kind = kind_icons[kind] or "" }
      end,
    })

    vim.keymap.set("i", "<C-s>", vim.lsp.buf.signature_help, {
      buffer = ev.buf,
      desc = "Signature help (replaces cmp-nvim-lsp-signature-help)",
    })
  end,
})

-- 'complete' has no path flag, so paths have to be a completefunc.
-- Completion starts after the last slash so accepting replaces only the
-- final segment, leaving what you typed (and any "~") intact.
local PATH_CHAR = "[%w%._%-/~$]"
local dir_prefix = ""

function _G.kk_path_complete(findstart, base)
  if findstart == 1 then
    local line = vim.api.nvim_get_current_line()
    local col = vim.fn.col(".") - 1

    local start = col
    while start > 0 and line:sub(start, start):match(PATH_CHAR) do
      start = start - 1
    end

    local token = line:sub(start + 1, col)
    if not token:find("/") then
      return -3
    end

    dir_prefix = token:match("^(.*/)")
    return start + #dir_prefix
  end

  local items = {}
  for _, path in ipairs(vim.fn.glob(dir_prefix .. base .. "*", false, true)) do
    local isdir = vim.fn.isdirectory(path) == 1
    local name = vim.fn.fnamemodify(path, ":t")
    table.insert(items, {
      word = isdir and (name .. "/") or name,
      kind = isdir and "󰉋" or "󰈙",
      menu = "[path]",
    })
  end
  return items
end

local function selected()
  return vim.fn.complete_info({ "selected" }).selected ~= -1
end

local function supermaven()
  local ok, preview = pcall(require, "supermaven-nvim.completion_preview")
  if ok and preview.has_suggestion() then
    return preview
  end
end

-- Supermaven binds <Tab> and <C-j> itself on InsertEnter, and mini.pairs owns
-- <CR>. Rather than depend on load order, these are installed after the first
-- InsertEnter has settled and delegate to the other owners explicitly.
-- (nvim-treesitter-endwise needs no handling: it watches the raw \r through
-- vim.on_key, so mappings never hide it from it.)
local function set_keymaps()
  local expr = { expr = true, silent = true }

  -- Deliberately not cmp's confirm({select = true}): under 'autocomplete' the
  -- menu is open far more often, so accepting an unselected item would turn
  -- ordinary newlines into accidental accepts.
  vim.keymap.set("i", "<CR>", function()
    if vim.fn.pumvisible() == 1 and selected() then
      return "<C-y>"
    end
    return _G.MiniPairs and MiniPairs.cr() or "<CR>"
  end, expr)

  vim.keymap.set("i", "<Tab>", function()
    if vim.fn.pumvisible() == 1 then
      return selected() and "<C-y>" or "<C-n><C-y>"
    end
    if vim.snippet.active({ direction = 1 }) then
      vim.schedule(function() vim.snippet.jump(1) end)
      return ""
    end
    local sm = supermaven()
    if sm then
      vim.schedule(sm.on_accept_suggestion)
      return ""
    end
    return "<Tab>"
  end, expr)

  vim.keymap.set("i", "<S-Tab>", function()
    if vim.snippet.active({ direction = -1 }) then
      vim.schedule(function() vim.snippet.jump(-1) end)
      return ""
    end
    return "<S-Tab>"
  end, expr)

  vim.keymap.set("i", "<C-j>", function()
    if vim.fn.pumvisible() == 1 then
      return "<C-n>"
    end
    local sm = supermaven()
    if sm then
      vim.schedule(sm.on_accept_suggestion_word)
      return ""
    end
    return "<C-j>"
  end, expr)

  vim.keymap.set("i", "<C-k>", function()
    return vim.fn.pumvisible() == 1 and "<C-p>" or "<C-k>"
  end, expr)

  vim.keymap.set("i", "<Down>", function()
    return vim.fn.pumvisible() == 1 and "<C-n>" or "<Down>"
  end, expr)

  vim.keymap.set("i", "<Up>", function()
    return vim.fn.pumvisible() == 1 and "<C-p>" or "<Up>"
  end, expr)

  vim.keymap.set("i", "<C-c>", function()
    vim.lsp.completion.get()
  end, { desc = "Trigger completion" })

  -- No <Esc> mapping for cmp's abort(): in a terminal <Up>/<Down> arrive as
  -- ESC-prefixed sequences, so mapping <Esc> in insert mode makes every
  -- Escape ambiguous and it stops reliably leaving insert mode. <C-e>
  -- dismisses the menu natively.
end

vim.api.nvim_create_autocmd("InsertEnter", {
  group = vim.api.nvim_create_augroup("kk_completion_keys", { clear = true }),
  once = true,
  callback = function()
    vim.schedule(set_keymaps)
  end,
})

-- Replaces cmp-cmdline.
vim.o.wildmode = "noselect:lastused,full"
vim.o.wildoptions = "pum"

vim.api.nvim_create_autocmd("CmdlineChanged", {
  group = vim.api.nvim_create_augroup("kk_completion_cmdline", { clear = true }),
  pattern = { ":", "/", "?" },
  callback = function()
    vim.fn.wildtrigger()
  end,
})

vim.keymap.set("c", "<Up>", function()
  return vim.fn.wildmenumode() == 1 and "<C-e><Up>" or "<Up>"
end, { expr = true })

vim.keymap.set("c", "<Down>", function()
  return vim.fn.wildmenumode() == 1 and "<C-e><Down>" or "<Down>"
end, { expr = true })
