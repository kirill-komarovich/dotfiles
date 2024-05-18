local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { "nvim-lua/plenary.nvim", lazy = true },
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    config = function()
      require("kirillkomarovich.plugin.devicons")
    end,
  },
  {
    "Mofiqul/vscode.nvim",
    lazy = false,
    priority = -1000,
    config = function()
      require("kirillkomarovich.plugin.vscode")

      vim.cmd [[colorscheme vscode]]
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    event = { "BufReadPre", "BufNewFile" },
    lazy = true,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      options = {
        theme = "vscode",
      },
      extensions = { "nvim-tree" }
    }
  },
  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    opts = {},
  },
  {
    "echasnovski/mini.surround",
    event = "VeryLazy",
    opts = {
      mappings = {
        add = "sa",            -- Add surrounding in Normal and Visual modes
        delete = "sd",         -- Delete surrounding
        find = "sn",           -- Find surrounding (to the right)
        find_left = "sF",      -- Find surrounding (to the left)
        highlight = "sh",      -- Highlight surrounding
        replace = "sr",        -- Replace surrounding
        update_n_lines = "sn", -- Update `n_lines`
      },
    },
  },
  {
    "numToStr/Comment.nvim",
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    config = function()
      require("kirillkomarovich.plugin.comment")
    end,
  },

  {
    'stevearc/oil.nvim',
    lazy = false,
    opts = {
      view_options = {
        show_hidden = true,
      },
      keymaps = {
        ["<C-p>"] = false,
        ["+"] = "actions.preview",
      }
    },
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
    },
    dependencies = {
      "nvim-tree/nvim-web-devicons"
    },
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      vim.opt.list = true
      vim.opt.listchars:append "space:⋅"
      vim.opt.listchars:append "eol:↴"

      require("ibl").setup({
        indent = { char = "▏" },
        scope = { enabled = false },
      })
    end
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",

      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-nvim-lsp-signature-help",
    },
    config = function()
      require("kirillkomarovich.plugin.cmp")
    end
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    lazy = true,
    event = { "BufReadPre", "BufNewFile" },
    cmd = "Mason",
    config = function()
      require("kirillkomarovich.plugin.lsp")
    end,
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
  },

  {
    "rgroli/other.nvim",
    cmd = "Other",
    opts = {
      mappings = {
        "rails",
      },
    }
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    lazy = true,
    config = function()
      require("kirillkomarovich.plugin.telescope")
    end,
    keys = function()
      local function load(fn)
        return function()
          return fn({
            builtin = require("telescope.builtin"),
            themes = require("telescope.themes"),
            egrepify = require("telescope").extensions.egrepify.egrepify,
          })
        end
      end

      return {
        {
          "<C-p>",
          load(function(telescope)
            telescope.builtin.find_files(telescope.themes.get_dropdown({
              hidden = true,
              file_ignore_patterns = { "^.git/", "^node_modules/", "^tmp/" },
              previewer = false,
            }))
          end),
          desc = "Find files by path with telescope.find_files",
        },
        {
          "<C-p>",
          load(function(telescope)
            vim.cmd('noau normal! "vy"')
            telescope.builtin.find_files(telescope.themes.get_dropdown({
              previewer = false,
              default_text = vim.fn.getreg("v"),
            }))
          end),
          mode = "v",
          desc = "Find files by path with telescope.find_files using current selected text",
        },
        {
          "<leader>fg",
          load(function(telescope)
            telescope.egrepify(telescope.themes.get_ivy())
          end),
          desc = "Find files by grep content with telescope.live_grep",
        },
        {
          "<leader>fg",
          load(function(telescope)
            vim.cmd('noau normal! "vy"')
            telescope.egrepify(telescope.themes.get_ivy({ default_text = vim.fn.getreg("v") }))
          end),
          mode = "v",
          silent = true,
          desc = "Find files by grep content with telescope.grep_string using current selected text",
        },
        {
          "<leader>fr",
          load(function(telescope)
            telescope.builtin.resume()
          end),
          desc = "Resume last telescope picker result",
        },
        {
          "<leader>fh",
          load(function(telescope)
            telescope.builtin.help_tags()
          end),
          desc = "Find content in help tags with telescope.help_tags",
        },
        {
          "<leader>fk",
          load(function(telescope)
            telescope.builtin.keymaps()
          end),
          desc = "Find content in keymaps with with telescope.keymaps",
        },
        {
          "<leader>b",
          load(function(telescope)
            telescope.builtin.buffers(telescope.themes.get_dropdown({
              previewer = false,
              sort_mru = true,
              initial_mode = "normal",
            }))
          end),
          desc = "Find opened buffers by path with telescope.buffers",
        },
        {
          "<leader>/",
          load(function(telescope)
            telescope.builtin.current_buffer_fuzzy_find(telescope.themes.get_ivy())
          end),
          desc = "Find content in current buffer with telescope.current_buffer_fuzzy_find",
        },
        {
          "<leader>/",
          load(function(telescope)
            vim.cmd('noau normal! "vy"')
            telescope.builtin.current_buffer_fuzzy_find(telescope.themes.get_ivy({ default_text = vim.fn.getreg("v") }))
          end),
          desc = "Find content in current buffer with telescope.current_buffer_fuzzy_find using current selected text",
        },
        {
          "<leader>gb",
          load(function(telescope)
            telescope.builtin.git_branches(telescope.themes.get_dropdown({ previewer = false }))
          end),
          desc = "Find git branges with telescope.git_branches",
        },
        {
          "<leader>ga",
          load(function(telescope)
            telescope.builtin.git_status({
              initial_mode = "normal",
              results_title = "",
              preview_title = "",
              path_display = { "truncate" },
            })
          end),
          desc = "Find files in current git status",
        },
        {
          "<leader>gc",
          load(function(telescope)
            telescope.builtin.git_commits({ initial_mode = "normal", results_title = "", preview_title = "" })
          end),
          desc = "Find git commits",
        },
        {
          "<leader>gh",
          load(function(telescope)
            telescope.builtin.git_bcommits({ initial_mode = "normal", results_title = "", preview_title = "" })
          end),
          desc = "Find current file git history",
        },
      }
    end,
    cmd = "Telescope",
    dependencies = {
      "nvim-telescope/telescope-media-files.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
      "fdschmidt93/telescope-egrepify.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
    },
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      {
        ensure_installed = "all",
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
          disable = function(_, buf)
            local max_filesize = 200 * 1024 -- 200 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end
          end,
        },
        indent = { enable = true, disable = { "" } },
        endwise = { enable = true },
        autotag = { enable = true },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts[1])
    end,
    dependencies = {
      "RRethy/nvim-treesitter-endwise",
      "romgrk/nvim-treesitter-context",
      "nvim-treesitter/nvim-treesitter-textobjects",
      "windwp/nvim-ts-autotag",
    },
  },

  -- Git
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("kirillkomarovich.plugin.gitsigns")
    end,
    dependencies = {
      "sindrets/diffview.nvim",
    },
  },

  {
    "johmsalas/text-case.nvim",
    config = function()
      require("textcase").setup({})
      require("telescope").load_extension("textcase")
    end,
    keys = {
      { "ga.", "<cmd>TextCaseOpenTelescope<CR>", mode = { "n", "v" }, desc = "Telescope" },
    },
  },
})
