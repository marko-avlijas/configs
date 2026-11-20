-- Neovim >= 0.12. No plugins (yet). The whole nvim/ directory of this repo
-- is linked to ~/.config/nvim.

-- Options
-- -------
vim.o.termguicolors = true      -- 24-bit color
vim.o.number = true
vim.o.colorcolumn = '80,120'

-- Indent with 2 spaces (Ruby style). Python gets 4 from Neovim's own
-- python ftplugin (PEP 8).
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.softtabstop = 2

-- Already Neovim defaults, unlike Vim: filetype plugin indent on, syntax on,
-- autoindent, hidden, the default colorscheme.

-- CTRL p: fuzzy file picker, built in
-- -----------------------------------
-- :find with a list that filters as you type (:help fuzzy-file-picker).
-- Files come from fd (fdfind on Debian/Ubuntu), which skips .gitignore'd
-- files; without fd, from a plain recursive glob.
local fd = vim.fn.executable('fd') == 1 and 'fd'
  or vim.fn.executable('fdfind') == 1 and 'fdfind'
  or nil
local files_cache = nil

local function project_files()
  if files_cache == nil then
    if fd then
      files_cache = vim.fn.systemlist({ fd, '--type', 'f', '--hidden', '--exclude', '.git' })
    else
      files_cache = vim.tbl_filter(function(f)
        return vim.fn.isdirectory(f) == 0
      end, vim.fn.globpath('.', '**', true, true))
      files_cache = vim.tbl_map(function(f) return vim.fn.fnamemodify(f, ':.') end, files_cache)
    end
  end
  return files_cache
end

function _G.FindFiles(arg, _)
  local files = project_files()
  return arg == '' and files or vim.fn.matchfuzzy(files, arg)
end

vim.o.findfunc = 'v:lua.FindFiles'
vim.o.wildmode = 'noselect:lastused,full'
vim.o.wildoptions = 'pum,fuzzy'

local group = vim.api.nvim_create_augroup('my_config', { clear = true })
-- fresh file list for every new command line
vim.api.nvim_create_autocmd('CmdlineEnter', {
  group = group, pattern = ':',
  callback = function() files_cache = nil end,
})
-- show suggestions while typing (commands, :find, / and ? searches)
vim.api.nvim_create_autocmd('CmdlineChanged', {
  group = group, pattern = { ':', '/', '?' },
  callback = function() vim.fn.wildtrigger() end,
})
-- Up/Down still walk the command history while the menu is open
vim.keymap.set('c', '<Up>', function()
  return vim.fn.wildmenumode() == 1 and '<C-e><Up>' or '<Up>'
end, { expr = true })
vim.keymap.set('c', '<Down>', function()
  return vim.fn.wildmenumode() == 1 and '<C-e><Down>' or '<Down>'
end, { expr = true })

vim.keymap.set('n', '<C-p>', ':find ', { desc = 'Find file (fuzzy)' })

-- CTRL n: file tree on the left, built in (netrw)
-- -----------------------------------------------
-- Enter opens (in the window on the right), - goes up a directory,
-- % new file, d new directory, R rename, D delete. :help netrw-quickmap
vim.g.netrw_banner = 0          -- no help header
vim.g.netrw_liststyle = 3       -- tree view
vim.g.netrw_browse_split = 4    -- open files in the previous window
vim.g.netrw_winsize = 25        -- width in percent

-- :Lexplore with a directory always opens; without one it toggles
vim.keymap.set('n', '<C-n>', function()
  if vim.t.netrw_lexbufnr then
    vim.cmd('Lexplore')
  else
    vim.cmd('Lexplore ' .. vim.fn.fnameescape(vim.fn.getcwd()))
  end
end, { desc = 'Toggle file tree' })
