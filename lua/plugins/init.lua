return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- test new blink
  -- { import = "nvchad.blink.lazyspec" },

  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
  --
    {
      "lewis6991/gitsigns.nvim",
      opts = function()
        local gitsigns = {
              signs = {
                add = { text = "│" },
                change = { text = "│" },
                delete = { text = "󰍵" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
                untracked = { text = "│" },
              },
            }

        gitsigns.current_line_blame_opts = {
            delay = 50,
        }

        return gitsigns
      end,
    },
  {
    "rust-lang/rust.vim",
    ft = "rust",
    init = function ()
      vim.g.rustfmt_autosave = 1
    end
  },
  {
    "saecki/crates.nvim",
    ft = {"rust", "toml"},
    config = function (_, opts)
      local crates = require("crates")
      crates.setup(opts)
    end
  },
  -- {
  --   "w0rp/ale",
  --   ft = { "markdown", "tex", "text", "rmd", "gitcommit" },
  --   cmd = { "ALEEnable" },
  -- },

  -- "tpope/vim-fugitive",

  { "ggandor/leap.nvim", lazy = false},
}
