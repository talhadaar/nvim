return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    config = function()
      require("tiny-inline-diagnostic").setup { preset = "minimal" }
      vim.diagnostic.config { virtual_text = false }
    end,
  },

  -- test new blink
  -- { import = "nvchad.blink.lazyspec" },

  {
    "folke/which-key.nvim",
    opts = function()
      return require "configs.whichkey"
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    cmd = { "TSUpdate", "TSUninstall", "TSLog" },
    opts = {
      ensure_installed = {
        "lua", "luadoc", "printf", "vim", "vimdoc",
        "python", "rust", "toml", "json",
      },
    },
  },
}
