local mason_config = require("mason-lspconfig")
local handlers = require("kirillkomarovich.plugin.lsp.handlers")

handlers.setup()
require("mason").setup()

mason_config.setup {
  ensure_installed = {
    "jsonls",
    "yamlls",
    "dockerls",
    "tailwindcss",
    "ts_ls",
    "lua_ls",
  },
}

local lang_settings = {
  lua_ls = {
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          library = {
            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
            [vim.fn.stdpath("config") .. "/lua"] = true,
          },
        },
      },
    },
  },
  rust_analyzer = {
    settings = {
      ["rust-analyzer"] = {
        checkOnSave = {
          command = "clippy",
        },
      },
    },
  },
  tailwindcss = {
    settings = {
      tailwindCSS = {
        classAttributes = { "class", "className", "ngClass", "\\w+_CLASSES", "classes" },
        includeLanguages = {
          rust = "html",
        },
      },
    },
  },
  yamlls = {
    settings = {
      yaml = {
        schemas = {
          ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
          ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = {
            "docker-compose.yml",
            "docker-compose.yaml",
            "docker-compose.*.yml",
            "docker-compose.*.yaml",
          },
        },
      },
    },
  },
  jsonls = {
    settings = {
      json = {
        schemas = {
          {
            description = "TypeScript compiler configuration file",
            fileMatch = {
              "tsconfig.json",
              "tsconfig.*.json",
            },
            url = "https://json.schemastore.org/tsconfig.json",
          },
          {
            description = "Babel configuration",
            fileMatch = {
              ".babelrc.json",
              ".babelrc",
              "babel.config.json",
            },
            url = "https://json.schemastore.org/babelrc.json",
          },
          {
            description = "ESLint config",
            fileMatch = {
              ".eslintrc.json",
              ".eslintrc",
            },
            url = "https://json.schemastore.org/eslintrc.json",
          },
          {
            description = "Prettier config",
            fileMatch = {
              ".prettierrc",
              ".prettierrc.json",
              "prettier.config.json",
            },
            url = "https://json.schemastore.org/prettierrc",
          },
          {
            description = "Stylelint config",
            fileMatch = {
              ".stylelintrc",
              ".stylelintrc.json",
              "stylelint.config.json",
            },
            url = "https://json.schemastore.org/stylelintrc",
          },
          {
            description = "NPM configuration file",
            fileMatch = { "package.json" },
            url = "https://json.schemastore.org/package.json",
          },
          {
            description = "Chrome Extension Manifest",
            fileMatch = { "manifest.json" },
            url = "https://json.schemastore.org/chrome-manifest.json",
          },
        },
      },
    },
    setup = {
      commands = {
        Format = {
          function()
            vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line "$", 0 })
          end,
        },
      },
    },
  },
}

mason_config.setup_handlers({
  function(server_name)
    local local_opts = vim.tbl_deep_extend(
      "force",
      lang_settings[server_name] or {},
      {
        on_attach = handlers.on_attach,
        capabilities = handlers.capabilities,
      }
    )

    require("lspconfig")[server_name].setup(local_opts)
  end,
})

require("lspconfig").gdscript.setup({
  on_attach = handlers.on_attach,
  capabilities = handlers.capabilities,
})

local null_ls = require("null-ls")

null_ls.setup()

require("mason-null-ls").setup({
  ensure_installed = {
    "cspell",
  },
  handlers = {
    require("mason-null-ls").default_setup,
    cspell = function(source_name, methods)
      print(source_name)
      print(vim.inspect(methods))

      null_ls.register(require("cspell").diagnostics)
      null_ls.register(require("cspell").code_actions)
    end,
    gdtoolkit = function()
      null_ls.register(null_ls.builtins.diagnostics.gdlint)
      null_ls.register(null_ls.builtins.formatting.gdformat.with({ extra_args = { "--use-spaces=2" } }))
    end,
  },
})
