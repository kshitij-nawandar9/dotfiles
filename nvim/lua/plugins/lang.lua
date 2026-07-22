-- Language support.
--
-- LazyVim ships these as "extras" — opt-in bundles that wire up LSP, treesitter,
-- mason and formatters consistently. Importing them is preferred over hand-rolling
-- lspconfig blocks (which is what the inert example.lua demonstrates).
--
-- Toggle interactively with `:LazyExtras`.
return {
  -- TypeScript / JavaScript: vtsls LSP, treesitter, mason.
  { import = "lazyvim.plugins.extras.lang.typescript" },

  -- Web stack used by the Next.js portal and the shared UI package.
  { import = "lazyvim.plugins.extras.lang.tailwind" },
  { import = "lazyvim.plugins.extras.lang.json" },

  -- Linting and formatting.
  { import = "lazyvim.plugins.extras.linting.eslint" },
  { import = "lazyvim.plugins.extras.formatting.prettier" },

  -- Postgres/Drizzle migrations.
  { import = "lazyvim.plugins.extras.lang.sql" },

  -- docker-compose / Dockerfiles for the local infra stack.
  { import = "lazyvim.plugins.extras.lang.docker" },

  -- Monorepo-friendly settings.
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        vtsls = {
          settings = {
            -- Workspace-wide rename/refs across turbo packages rather than
            -- stopping at the current app's tsconfig boundary.
            typescript = {
              tsserver = { maxTsServerMemory = 8192 },
              preferences = {
                -- Repo is ESM: relative imports must carry .js extensions.
                importModuleSpecifierEnding = "js",
              },
            },
          },
        },
      },
    },
  },
}
