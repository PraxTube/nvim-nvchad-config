require "nvchad.mappings"

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "<leader>s", 
      function()
        local focusable_windows_on_tabpage = vim.tbl_filter(
          function (win) return vim.api.nvim_win_get_config(win).focusable end,
          vim.api.nvim_tabpage_list_wins(0)
        )
        require('leap').leap { target_windows = focusable_windows_on_tabpage }
      end, { desc = "Jump to Word"}
)

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
