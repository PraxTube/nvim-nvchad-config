require "nvchad.mappings"

local map = vim.keymap.set

map("n", "<leader>s", 
      function()
        local focusable_windows_on_tabpage = vim.tbl_filter(
          function (win) return vim.api.nvim_win_get_config(win).focusable end,
          vim.api.nvim_tabpage_list_wins(0)
        )
        require('leap').leap { target_windows = focusable_windows_on_tabpage }
      end, { desc = "Jump to Word"}
)

map("n", "<leader>ra", 
      function()
        local word = vim.fn.expand("<cword>")
        if word == "" then return end

        vim.fn.setreg("/", "\\<" .. word .. "\\>")
        vim.opt.hlsearch = true
        vim.cmd("redraw!")

        local new_name = vim.fn.input("Rename '" .. word .. "' to: ")
        if new_name == "" then return end

        vim.cmd("%s/\\<" .. word .. "\\>/" .. new_name .. "/g")
      end, { desc = "Rename"}
)

map("v", ">", ">gv")
map("v", "<", "<gv")

map("n", "j", "gj")
map("n", "k", "gk")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
-- map("i", "jk", "<ESC>")
