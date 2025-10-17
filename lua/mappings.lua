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

map("n", "<leader>o", ":vsplit | terminal odin run . -debug<CR> | G", { desc = "Run Odin in Term"})
map("n", "<leader>O", ":!odin build . -debug<CR>", { desc = "Build Odin as CMD"})

vim.api.nvim_create_autocmd("TermClose", {
  pattern = "*odin run*",
  callback = function(args)
    local bufnr = args.buf
    -- Check if the buffer still exists and is a terminal
    if vim.api.nvim_buf_is_valid(bufnr) then
      -- Close the window if it's visible
      for _, win in ipairs(vim.fn.win_findbuf(bufnr)) do
        vim.api.nvim_win_close(win, true)
      end
      -- Wipe out the buffer (removes it completely)
      vim.api.nvim_buf_delete(bufnr, { force = true })
    end
  end,
})

local function run_odin_build()
    vim.cmd("!odin build . -debug")
    if vim.v.shell_error == 0 then
          vim.cmd("redraw!")
          vim.notify("✅ Odin build succeeded", vim.log.levels.INFO)
    else
          vim.notify("❌ Odin build failed", vim.log.levels.ERROR)
    end
end

vim.keymap.set("n", "<leader>O", run_odin_build, { desc = "Build Odin" })

local function grep_and_open_async()
  local word = vim.fn.expand("<cword>")
  if word == "" then
    print("No word under cursor")
    return
  end

  -- Escape any regex special chars in the word (important!)
  local safe_word = vim.fn.escape(word, "\\/.*$^~[]")
  local pattern = string.format("\\b%s\\b\\s*::", safe_word)

  local cmd = { "rg", "--vimgrep", "--pcre2", pattern, "." }

  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if not data or #data == 0 or data[1] == "" then
        vim.schedule(function()
          print("No matches found for: " .. pattern)
        end)
        return
      end

      -- Parse first match (filename:line:col:text)
      local first = data[1]
      local filename, lnum, col = first:match("([^:]+):(%d+):(%d+):")

      if not filename then
        vim.schedule(function()
          print("Could not parse rg result: " .. first)
        end)
        return
      end

      vim.schedule(function()
        vim.cmd("normal! m'")

        -- Check if file is already open
        local bufnr = vim.fn.bufnr(filename)
        if bufnr ~= -1 then
          vim.cmd("buffer " .. bufnr)
        else
          vim.cmd("edit " .. filename)
        end

        vim.api.nvim_win_set_cursor(0, { tonumber(lnum), tonumber(col) - 1 })
        vim.cmd("normal! zz")
        print("Opened first match for: " .. word .. " ::")
      end)
    end,
  })
end

vim.keymap.set("n", "go", grep_and_open_async, { noremap = true, silent = true, desc = "Async grep <cword> :: and open first match" })
