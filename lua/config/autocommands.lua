local function set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
end

vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter' }, {
  pattern = { '*' },
  command = 'checktime',
})

vim.api.nvim_create_autocmd({ 'TermOpen' }, {
  pattern = { '*' },
  callback = function(_)
    vim.cmd.setlocal 'nonumber'
    vim.cmd.setlocal 'norelativenumber'
    vim.opt_local.cursorline = false
    vim.opt_local.list = false

    -- minimal terminal: subtle background, no winbar, clean look
    local term_bg = '#0d1117'
    local ns = vim.api.nvim_create_namespace 'terminal_bg'
    vim.api.nvim_set_hl(ns, 'Normal', { bg = term_bg })
    vim.api.nvim_set_hl(ns, 'EndOfBuffer', { fg = term_bg, bg = term_bg })
    vim.api.nvim_set_hl(ns, 'SignColumn', { bg = term_bg })
    vim.api.nvim_set_hl(ns, 'FoldColumn', { bg = term_bg })
    vim.api.nvim_set_hl(ns, 'WinSeparator', { fg = '#1c1e25', bg = 'NONE' })
    vim.api.nvim_win_set_hl_ns(0, ns)

    -- left padding via foldcolumn (acts as visual margin)
    vim.wo.signcolumn = 'no'
    vim.wo.foldcolumn = '1'

    -- no winbar for clean minimal look
    vim.wo.winbar = nil

    set_terminal_keymaps()
  end,
})

-- Auto-scroll R terminal to bottom when entering (Radian and vanilla R only)
-- Note: Only BufEnter is used (not TermEnter) to avoid "Can't re-enter normal mode from terminal mode" error
vim.api.nvim_create_autocmd({ 'BufEnter' }, {
  pattern = { 'term://*' },
  callback = function()
    -- Only auto-scroll if this is an R terminal
    if vim.b.is_r_terminal then
      vim.opt_local.scrolloff = 0
      vim.cmd 'normal! G'
    end
  end,
})

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Hide tabline (bufferline) on dashboard, restore on other buffers
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'snacks_dashboard',
  callback = function()
    vim.opt.showtabline = 0
  end,
})
vim.api.nvim_create_autocmd('BufUnload', {
  callback = function()
    if vim.bo.filetype == 'snacks_dashboard' then
      vim.opt.showtabline = 2
    end
  end,
})
