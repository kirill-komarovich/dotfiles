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

-- Example using a list of specs with the default options
vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct

require("lazy").setup({
  { "nvim-lua/plenary.nvim",        lazy = true },
  { "kyazdani42/nvim-web-devicons", lazy = true },
  {
    "Mofiqul/vscode.nvim",
    lazy = false,
    config = function()
      require("kirillkomarovich.theme")
    end,
    dependencies = { "kyazdani42/nvim-web-devicons" },
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "kyazdani42/nvim-web-devicons" },
    opts = {
      options = {
        theme = 'vscode',
      },
      extensions = { "nvim-tree" }
    }
  },
  {
    "windwp/nvim-autopairs",
    opts = {
      check_ts = true,
      enable_check_bracket_line = false,
      ts_config = {
        lua = { "string", "source" },
        javascript = { "string", "template_string" },
      },
      fast_wrap = {
        map = "<M-e>",
        chars = { "{", "[", "(", '"', "'" },
        pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
        offset = 0, -- Offset from pattern match
        end_key = "$",
        keys = "qwertyuiopzxcvbnmasdfghjkl",
        check_comma = true,
        highlight = "PmenuSel",
        highlight_grey = "LineNr",
      },
    },
  },

  { "kylechui/nvim-surround" },

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
    "nvim-tree/nvim-tree.lua",
    lazy = false,
    config = function()
      require("kirillkomarovich.plugin.nvimtree")
    end,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
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

  -- cmp plugins
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
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "jose-elias-alvarez/null-ls.nvim",
      "jay-babu/mason-null-ls.nvim",
    },
  },

  {
    "rgroli/other.nvim",
    main = "other-nvim",
    opts = {
      mappings = {
        "rails",
      },
    }
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    config = function()
      require("kirillkomarovich.plugin.telescope")
    end,
    keys = require("kirillkomarovich.plugin.telescope.keys"),
    dependencies = {
      "nvim-telescope/telescope-media-files.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = 'make',
      },
      "fdschmidt93/telescope-egrepify.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
    },
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("kirillkomarovich.plugin.treesitter")
    end,
    dependencies = {
      "nvim-treesitter/playground",
      "romgrk/nvim-treesitter-context",
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
  },

  -- Git
  "lewis6991/gitsigns.nvim",
  "sindrets/diffview.nvim",

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
