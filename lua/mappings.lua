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

vim.api.nvim_create_autocmd("TermClose", {
  pattern = "run.sh*",
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

local function find_script(start_dir, script_name)
    local Path = require("plenary.path") 
    local dir = Path:new(start_dir)

    while dir.filename ~= "/" do
        local build_script = dir:joinpath(script_name)
        if build_script:exists() then
            return build_script:absolute()
        end
        dir = dir:parent()
    end

    return nil
end

local function run_build_script()
    local cwd = vim.fn.getcwd()
    local build_script = find_script(cwd, "build.sh")

    if not build_script then
        vim.notify("⚠️ No build.sh found in current or parent directories", vim.log.levels.WARN)
        return
    end

    local cmd = string.format("bash %s", vim.fn.shellescape(build_script))
    vim.cmd("!" .. cmd)

    if vim.v.shell_error == 0 then
          vim.cmd("redraw!")
          vim.notify("✅ Build succeeded", vim.log.levels.INFO)
    else
          vim.notify("❌ Build failed", vim.log.levels.ERROR)
    end
end

local function run_run_script()
    local cwd = vim.fn.getcwd()
    local run_script = find_script(cwd, "run.sh")

    if not run_script then
        vim.notify("⚠️ No run.sh found in current or parent directories", vim.log.levels.WARN)
        return
    end

    local cmd = string.format("bash %s", vim.fn.shellescape(run_script))
    vim.cmd("vsplit")
    vim.cmd("terminal " .. cmd)
    vim.cmd("normal! G")

    -- if vim.v.shell_error == 0 then
    --       vim.cmd("redraw!")
    --       vim.notify("✅ Build succeeded", vim.log.levels.INFO)
    -- else
    --       vim.notify("❌ Build failed", vim.log.levels.ERROR)
    -- end
end

map("n", "<leader>o", run_run_script, { desc = "Run run.sh"})
map("n", "<leader>O", run_build_script, { desc = "Run build.sh" })

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
