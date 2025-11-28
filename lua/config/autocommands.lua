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
    vim.wo.signcolumn = 'no'
    set_terminal_keymaps()
  end,
})

-- Auto-scroll R terminal to bottom when entering (Radian and vanilla R only)
-- Also enable bracketed paste for R terminals
vim.api.nvim_create_autocmd({ 'BufEnter', 'TermEnter' }, {
  pattern = { 'term://*' },
  callback = function()
    -- Only auto-scroll if this is an R terminal
    if vim.b.is_r_terminal then
      vim.opt_local.scrolloff = 0
      vim.cmd 'normal! G'
      -- Enable bracketed paste for R terminals (Radian needs this)
      vim.g.slime_bracketed_paste = 1
    else
      -- Disable bracketed paste for non-R terminals (e.g., IPython)
      vim.g.slime_bracketed_paste = 0
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
