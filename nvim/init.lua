-- Neovim >= 0.12. Plugins come from the built-in vim.pack (see the end of
-- this file). The whole nvim/ directory of this repo is linked to
-- ~/.config/nvim.

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

-- Plugins: vim.pack, built in
-- ---------------------------
-- Every plugin is pinned to a commit I have reviewed. The lockfile
-- nvim-pack-lock.json next to this file is in git too. install-plugins.sh
-- (run by create_symlinks.sh) installs them, or run nvim once.
--
-- To update one: put the new commit here, restart, then
--   :lua vim.pack.update({ 'render-markdown.nvim' })
-- shows the new commits; read them, :write applies, :quit refuses.
-- Commit init.lua together with the lockfile.
vim.pack.add({
  {
    src = 'https://github.com/MeanderingProgrammer/render-markdown.nvim',
    version = '640a3ec6d538bad17c328be373c7cad0293d9589',  -- v8.14.0, 2026-09-14
  },
  {
    -- file type icons for render-markdown (code blocks); needs a Nerd Font
    src = 'https://github.com/nvim-tree/nvim-web-devicons',
    version = '0dc0cfb0c6858041174a53c7aa4adaf65e994b3c',  -- master, 2026-11-06
  },
}, { confirm = false })   -- pinned, so no question on first start

-- render-markdown: draws headings, lists, tables, code blocks in the buffer.
-- Uses the markdown parsers that ship with Neovim. :RenderMarkdown toggle
require('render-markdown').setup({
  latex = { enabled = false },   -- would run utftex / latex2text if installed
  html = { enabled = false },    -- no html and yaml parsers in Neovim itself
  yaml = { enabled = false },
})
