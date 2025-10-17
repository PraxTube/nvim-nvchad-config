require "nvchad.options"

-- add yours here!

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!


vim.cmd('autocmd FileType c setlocal shiftwidth=4')
vim.cmd('autocmd FileType c setlocal tabstop=4')

vim.cmd('autocmd FileType cpp setlocal shiftwidth=4')
vim.cmd('autocmd FileType cpp setlocal tabstop=4')

vim.cmd('autocmd FileType r setlocal shiftwidth=4')
vim.cmd('autocmd FileType r setlocal tabstop=4')

vim.cmd('autocmd FileType java setlocal shiftwidth=4')
vim.cmd('autocmd FileType java setlocal tabstop=4')

vim.cmd('autocmd FileType javascript setlocal shiftwidth=2')
vim.cmd('autocmd FileType javascript setlocal tabstop=2')

vim.cmd('autocmd FileType python setlocal shiftwidth=4')
vim.cmd('autocmd FileType python setlocal tabstop=4')

vim.cmd('autocmd FileType rst setlocal shiftwidth=4')
vim.cmd('autocmd FileType rst setlocal tabstop=4')

vim.cmd('autocmd FileType sql setlocal shiftwidth=4')
vim.cmd('autocmd FileType sql setlocal tabstop=4')

vim.cmd('autocmd FileType gdshader setlocal shiftwidth=4')
vim.cmd('autocmd FileType gdshader setlocal tabstop=4')

vim.cmd('autocmd FileType kdl setlocal shiftwidth=4')
vim.cmd('autocmd FileType kdl setlocal tabstop=4')

vim.cmd('autocmd FileType wgsl setlocal shiftwidth=4')
vim.cmd('autocmd FileType wgsl setlocal tabstop=4')

vim.cmd('autocmd FileType yarn setlocal shiftwidth=4')
vim.cmd('autocmd FileType yarn setlocal tabstop=4')
vim.cmd('autocmd FileType yarn set commentstring=//%s')

vim.cmd('autocmd FileType nu setlocal shiftwidth=4')
vim.cmd('autocmd FileType nu setlocal tabstop=4')

vim.cmd('autocmd FileType ron setlocal shiftwidth=4')
vim.cmd('autocmd FileType ron setlocal tabstop=4')

vim.cmd('autocmd FileType lua setlocal shiftwidth=4')
vim.cmd('autocmd FileType lua setlocal tabstop=4')

vim.cmd('autocmd FileType json setlocal shiftwidth=4')
vim.cmd('autocmd FileType json setlocal tabstop=4')

vim.cmd('autocmd FileType odin setlocal shiftwidth=4')
vim.cmd('autocmd FileType odin setlocal tabstop=4')

vim.cmd('autocmd FileType glsl setlocal shiftwidth=4')
vim.cmd('autocmd FileType glsl setlocal tabstop=4')

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.wgsl",
  callback = function()
    vim.bo.filetype = "wgsl"
  end,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.fs",
  callback = function()
    vim.bo.filetype = "glsl"
  end,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.vs",
  callback = function()
    vim.bo.filetype = "glsl"
  end,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.yarn",
  callback = function()
    vim.bo.filetype = "yarn"
  end,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.nu",
  callback = function()
    vim.bo.filetype = "nu"
  end,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.trickfilm",
  callback = function()
    vim.bo.filetype = "trickfilm"
  end,
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = "*/atlas.odin",
  callback = function()
        vim.cmd("TSDisable highlight")
        vim.cmd("syntax on")
  end,
})

vim.api.nvim_create_autocmd({ "BufUnload" }, {
  pattern = "*/atlas.odin",
  callback = function()
        vim.cmd("syntax off")
        vim.cmd("TSEnable highlight")
  end,
})

vim.filetype.add({
    extension = {
        ldtk = "json",
    }
})

-- vim.api.nvim_set_option("clipboard","unnamed")

vim.cmd('set clipboard+=unnamedplus')

vim.cmd('set grepprg=rg')

vim.opt.grepprg = "rg --vimgrep --smart-case --hidden"
-- vim.cmd('set grepprg=rg --vimgrep --smart-case --hidden')
-- vim.cmd('set grepformat=%f:%l:%c:%m')

vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", {
  fg = "#586e75",
  italic = true,
})

-- vim.api.nvim_create_autocmd("BufWritePre", {
--   pattern = "*.odin",
--   callback = function()
--     vim.cmd([[%!odinfmt]])
--   end,
-- })

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.odin",
  callback = function()
    -- local view = vim.fn.winsaveview()
    vim.cmd("silent! !odinfmt -w %")
    vim.cmd("checktime")
    -- vim.fn.winrestview(view)
  end,
})
