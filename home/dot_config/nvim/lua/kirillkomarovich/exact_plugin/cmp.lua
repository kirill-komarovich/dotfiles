vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.shortmess:append("c")

local luasnip = require("luasnip")

require("luasnip/loaders/from_vscode").lazy_load()
local nvim_create_augroup = vim.api.nvim_create_augroup
local nvim_create_autocmd = vim.api.nvim_create_autocmd

LuasnipGroup = nvim_create_augroup('LuasnipGroup', { clear = true })
-- Stop snippets when you leave to normal mode
nvim_create_autocmd("ModeChanged", {
  pattern = "*",
  group = LuasnipGroup,
  callback = function()
    if ((vim.v.event.old_mode == 's' and vim.v.event.new_mode == 'n') or vim.v.event.old_mode == 'i')
        and luasnip.session.current_nodes[vim.api.nvim_get_current_buf()]
        and not luasnip.session.jump_active then
      luasnip.unlink_current()
    end
  end,
})

local check_backspace = function()
  local col = vim.fn.col "." - 1
  return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
end

local cmp = require("cmp")

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  window = {
    documentation = cmp.config.window.bordered(),
  },
  mapping = {
    ["<UP>"] = cmp.mapping.select_prev_item(),
    ["<C-k>"] = cmp.mapping.select_prev_item(),
    ["<DOWN>"] = cmp.mapping.select_next_item(),
    ["<C-j>"] = cmp.mapping.select_next_item(),
    ["<C-UP>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
    -- ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
    -- TODO: fix this
    ["<C-d>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.scroll_docs(-1)
      else
        fallback()
      end
    end, { "i", "c" }),
    ["<C-DOWN>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
    -- ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
    ["<C-u>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.scroll_docs(1)
      else
        fallback()
      end
    end, { "i", "c" }),

    ["<C-c>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
    -- ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ["<ESC>"] = cmp.mapping {
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    },
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.confirm { select = true } -- auto select first item
      elseif luasnip.expandable() then
        luasnip.expand()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif check_backspace() then
        fallback()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "nvim_lua" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "path" },
  },
  formatting = {
    format = require("lspkind").cmp_format({
      mode = "symbol_text",
      show_labelDetails = true,
      maxwidth = 50,
      before = function (entry, vim_item)
        if entry.source.name == "nvim_lsp" then
          vim_item.menu = "[" .. entry.source.source.client.name .. "]"
        end

        return vim_item
      end
    }),
  },
  confirm_opts = {
    behavior = cmp.ConfirmBehavior.Replace,
    select = false,
  },
})

cmp.setup.cmdline("/", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" },
    { name = "cmdline_history" },
  }
})

cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" },
    { name = "cmdline_history" },
    { name = "buffer" },
  })
})
