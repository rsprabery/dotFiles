" Personal Neovim configuration

" ============================================================================
" Core bootstrap
" ============================================================================

set nocompatible
let mapleader = ","

let s:lazy_dir = expand('~/.local/share/nvim/lazy/lazy.nvim')
if empty(glob(s:lazy_dir))
  echohl WarningMsg
  echom 'lazy.nvim is not installed. Run: git clone --filter=blob:none https://github.com/folke/lazy.nvim.git ' . s:lazy_dir
  echohl None
else
  execute 'set rtp^=' . fnameescape(s:lazy_dir)
endif

" ============================================================================
" Providers and plugin declarations
" ============================================================================

" Prefer python 3 if available.
if filereadable('/Users/read/workspace/virtenvs/p3neovim/bin/python')
  let g:python_host_prog = '/Users/read/workspace/virtenvs/p3neovim/bin/python'
  let g:python3_host_prog = '/Users/read/workspace/virtenvs/p3neovim/bin/python'
endif

lua << EOF
require('lazy').setup({
  { 'vim-python/python-syntax' },
  { 'python/black' },
  { 'vim-ruby/vim-ruby' },
  { 'vim-scripts/indentpython.vim' },
  { 'rhysd/vim-crystal' },
  { 'octol/vim-cpp-enhanced-highlight' },
  { 'keith/xcconfig.vim' },

  { 'christoomey/vim-tmux-navigator' },
  { 'tpope/vim-fugitive' },
  { 'Lokaltog/vim-easymotion' },
  { 'tpope/vim-rails' },
  { 'rizzatti/dash.vim' },
  { 'majutsushi/tagbar' },
  { 'scrooloose/nerdtree' },
  { 'junegunn/fzf' },
  { 'junegunn/fzf.vim' },
  { 'vim-scripts/VisIncr' },

  { 'airblade/vim-gitgutter' },
  { 'vim-airline/vim-airline' },
  { 'vim-airline/vim-airline-themes' },
  { 'heavenshell/vim-pydocstring' },
  { 'tpope/vim-commentary' },
  { 'junegunn/vim-easy-align' },
  { 'tomasiser/vim-code-dark' },

  { 'neovim/nvim-lspconfig' },
  { 'williamboman/mason.nvim' },
  { 'williamboman/mason-lspconfig.nvim' },
  { 'hrsh7th/nvim-cmp' },
  { 'hrsh7th/cmp-nvim-lsp' },

  { 'rsprabery/vim-tmux-clipboard' },
}, {
  checker = { enabled = false },
  change_detection = { notify = false },
})
EOF

filetype plugin indent on
syntax enable

" ============================================================================
" Global options
" ============================================================================

set number
set mouse=a
set clipboard+=unnamedplus
set signcolumn=yes
set cindent
set smartindent
set autoindent
set expandtab
set shiftwidth=4
set tabstop=4
set colorcolumn=81
set completeopt=menu,menuone,noselect
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<,space:␣
set hlsearch
set nospell

let g:python_highlight_all = 1
let g:dash_activate = 0
let g:gitgutter_map_keys = 0
let g:crystal_auto_format = 1
let g:airline_theme = 'codedark'
let g:airline#extensions#branch#enabled = 0
let g:airline#extensions#hunks#enabled = 0
let g:airline#extensions#whitespace#enabled = 0
let g:airline#parts#ffenc#skip_expected_string = 'utf-8[unix]'

if filereadable('/Users/read/workspace/virtenvs/black-vim/bin/activate')
  let g:black_virtualenv = '/Users/read/workspace/virtenvs/black-vim/'
elseif filereadable('/home/read/workspace/virtenvs/black-vim/bin/activate')
  let g:black_virtualenv = '/home/read/workspace/virtenvs/black-vim/'
endif

if executable('/Users/read/brew/bin/fzf')
  set rtp+=/Users/read/brew/opt/fzf
elseif executable('/opt/homebrew/bin/fzf')
  set rtp+=/opt/homebrew/opt/fzf
elseif executable('/usr/bin/fzf')
  set rtp+=/usr/bin/fzf
endif

if exists('$GOROOT')
  execute 'set rtp+=' . fnameescape($GOROOT . '/misc/vim')
endif

colorscheme codedark

" ============================================================================
" Modern LSP and completion setup
" ============================================================================

lua << EOF
local ok_mason, mason = pcall(require, 'mason')
if ok_mason then
  mason.setup()
end

local ok_mason_lsp, mason_lspconfig = pcall(require, 'mason-lspconfig')
if ok_mason_lsp then
  mason_lspconfig.setup({
    automatic_installation = false,
  })
end

local ok_cmp, cmp = pcall(require, 'cmp')
local capabilities = vim.lsp.protocol.make_client_capabilities()
if ok_cmp then
  capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
  cmp.setup({
    completion = {
      completeopt = 'menu,menuone,noselect',
    },
    mapping = cmp.mapping.preset.insert({
      ['<Tab>'] = cmp.mapping.select_next_item(),
      ['<S-Tab>'] = cmp.mapping.select_prev_item(),
      ['<CR>'] = cmp.mapping.confirm({ select = false }),
      ['<C-Space>'] = cmp.mapping.complete(),
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
    }),
  })
end

vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = 'rounded',
    source = 'if_many',
  },
})

local on_attach = function(_, bufnr)
  local opts = { buffer = bufnr, silent = true }
  vim.keymap.set({ 'n', 'v' }, '}', vim.lsp.buf.definition, opts)
  vim.keymap.set({ 'n', 'v' }, '{', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', 'F', vim.lsp.buf.references, opts)
  vim.keymap.set({ 'n', 'v' }, '<leader>f', vim.lsp.buf.code_action, opts)
end

local function setup(server, opts)
  vim.lsp.config(server, vim.tbl_extend('force', {
    capabilities = capabilities,
    on_attach = on_attach,
  }, opts or {}))
  vim.lsp.enable(server)
end

if vim.fn.executable('clangd') == 1 then
  setup('clangd')
end

if vim.fn.executable('gopls') == 1 then
  setup('gopls')
end

if vim.fn.executable('bundle') == 1 then
  setup('ruby_lsp', {
    cmd = { 'bundle', 'exec', 'ruby-lsp' },
    filetypes = { 'ruby', 'eruby' },
    root_markers = { 'Gemfile', '.git' },
  })
elseif vim.fn.executable('ruby-lsp') == 1 then
  setup('ruby_lsp', {
    cmd = { 'ruby-lsp' },
    filetypes = { 'ruby', 'eruby' },
    root_markers = { 'Gemfile', '.git' },
  })
end

if vim.fn.executable('/Users/read/workspace/virtenvs/p3neovim/bin/pylsp') == 1 then
  setup('pylsp', { cmd = { '/Users/read/workspace/virtenvs/p3neovim/bin/pylsp' } })
elseif vim.fn.executable('/Users/read/workspace/virtenvs/pylsp/bin/pylsp') == 1 then
  setup('pylsp', { cmd = { '/Users/read/workspace/virtenvs/pylsp/bin/pylsp' } })
elseif vim.fn.executable('pylsp') == 1 then
  setup('pylsp')
elseif vim.fn.executable('/Users/read/workspace/virtenvs/p3neovim/bin/pyls') == 1 then
  setup('pylsp', { cmd = { '/Users/read/workspace/virtenvs/p3neovim/bin/pyls' } })
elseif vim.fn.executable('/Users/read/workspace/virtenvs/pylsp/bin/pyls') == 1 then
  setup('pylsp', { cmd = { '/Users/read/workspace/virtenvs/pylsp/bin/pyls' } })
elseif vim.fn.executable('pyls') == 1 then
  setup('pylsp', { cmd = { 'pyls' } })
end

if vim.fn.executable('/Users/read/brew/bin/bash-language-server') == 1 then
  setup('bashls', { cmd = { '/Users/read/brew/bin/bash-language-server', 'start' } })
elseif vim.fn.executable('bash-language-server') == 1 then
  setup('bashls')
end
EOF

" ============================================================================
" Helper functions
" ============================================================================

function! s:first_preproc_line() abort
  keepjumps normal! gg
  if search('^#', 'W') > 0
    let l:first = line('.')
    keepjumps normal! gg
    return l:first
  endif

  keepjumps normal! gg
  return 1
endfunction

function! s:tabs_or_spaces() abort
  if &buftype !=# '' || getfsize(expand('%:p')) > 256000
    return
  endif

  let l:start_line = 1
  if index(['c', 'cpp'], &filetype) >= 0
    let l:start_line = s:first_preproc_line()
  endif

  let l:max_line = min([line('$'), 1000])
  let l:lines = getline(l:start_line, l:max_line)
  let l:num_tabs = len(filter(copy(l:lines), 'v:val =~ "^\\t"'))
  let l:num_spaces = len(filter(copy(l:lines), 'v:val =~ "^ "'))

  if l:num_tabs > l:num_spaces
    setlocal noexpandtab
  else
    setlocal expandtab
  endif
endfunction

function! s:toggle_colorcolumn() abort
  if &colorcolumn ==# '81'
    set colorcolumn=
  else
    set colorcolumn=81
  endif
endfunction

function! s:toggle_spell() abort
  setlocal spell!
endfunction

function! s:fix_whitespace() abort
  if &buftype !=# '' || &modifiable == 0
    return
  endif

  let l:view = winsaveview()
  silent! keeppatterns %s/\s\+$//e
  call winrestview(l:view)
endfunction

function! s:clear_terminal_scrollback() abort
  if &buftype ==# 'terminal'
    setlocal scrollback=1
    setlocal scrollback=10000
  endif
endfunction

function! s:is_fzf_terminal() abort
  return &filetype ==# 'fzf' || bufname('%') =~# 'FZF'
endfunction

function! s:setup_terminal_mappings() abort
  setlocal nonumber nospell nocursorline

  if s:is_fzf_terminal()
    tnoremap <buffer> <Esc> <C-c>
    nnoremap <buffer> <Esc> :close<CR>
  else
    tnoremap <buffer> <Esc> <C-\><C-n>
  endif

  tnoremap <buffer> <leader>k <C-\><C-n>:call <SID>clear_terminal_scrollback()<CR>i
  nnoremap <buffer> <leader>k :call <SID>clear_terminal_scrollback()<CR>
endfunction

function! s:grep_word_under_cursor() abort
  let l:word = expand('<cword>')
  if empty(l:word)
    return
  endif

  silent execute 'grep! "\b' . escape(l:word, '\') . '\b"'
  botright copen 8
  set colorcolumn= nospell
endfunction

function! s:has_lsp_client() abort
  return luaeval('#vim.lsp.get_clients({ bufnr = 0 }) > 0')
endfunction

function! s:lsp_has_definition() abort
  return luaeval("(function() local params = vim.lsp.util.make_position_params(0, 'utf-8'); local results = vim.lsp.buf_request_sync(0, 'textDocument/definition', params, 800); if not results then return false end; for _, response in pairs(results) do local result = response.result; if result and ((type(result) == 'table' and result.uri) or next(result) ~= nil) then return true end end; return false end)()")
endfunction

function! s:lsp_has_hover() abort
  return luaeval("(function() local params = vim.lsp.util.make_position_params(0, 'utf-8'); local results = vim.lsp.buf_request_sync(0, 'textDocument/hover', params, 800); if not results then return false end; for _, response in pairs(results) do local result = response.result; if result and result.contents then local contents = result.contents; if type(contents) == 'string' then return contents ~= '' end; if type(contents) == 'table' then return next(contents) ~= nil end end end; return false end)()")
endfunction

function! s:current_template_suffix() abort
  let l:name = expand('%:t')
  let l:match = matchstr(l:name, '\..*$')
  return empty(l:match) ? '.html.erb' : l:match
endfunction

function! s:project_root() abort
  let l:gemfile = findfile('Gemfile', expand('%:p:h') . ';')
  if !empty(l:gemfile)
    return fnamemodify(l:gemfile, ':h')
  endif

  let l:gitdir = finddir('.git', expand('%:p:h') . ';')
  if !empty(l:gitdir)
    return fnamemodify(l:gitdir, ':h')
  endif

  return getcwd()
endfunction

function! s:jump_to_erb_partial() abort
  if &filetype !=# 'eruby'
    return 0
  endif

  let l:raw = expand('<cfile>')
  if empty(l:raw) || l:raw =~# '^\s*$'
    return 0
  endif

  let l:partial_ref = substitute(l:raw, '^["'']\|["'']$', '', 'g')
  if empty(l:partial_ref)
    return 0
  endif

  let l:suffix = s:current_template_suffix()
  let l:base = fnamemodify(l:partial_ref, ':t')
  let l:dirname = fnamemodify(l:partial_ref, ':h')
  let l:candidates = []

  if l:dirname ==# '.'
    call add(l:candidates, expand('%:p:h') . '/_' . l:base . l:suffix)
    call add(l:candidates, expand('%:p:h') . '/_' . l:base . '.erb')
  else
    let l:views_root = s:project_root() . '/app/views'
    call add(l:candidates, l:views_root . '/' . l:dirname . '/_' . l:base . l:suffix)
    call add(l:candidates, l:views_root . '/' . l:dirname . '/_' . l:base . '.erb')
  endif

  for l:candidate in l:candidates
    if filereadable(l:candidate)
      execute 'edit ' . fnameescape(fnamemodify(l:candidate, ':p'))
      return 1
    endif
  endfor

  return 0
endfunction

function! s:jump_to_route_target() abort
  if expand('%:t') !=# 'routes.rb'
    return 0
  endif

  let l:line = getline('.')
  let l:match = matchlist(l:line, '\v["'']([a-zA-Z0-9_/]+)#([a-zA-Z0-9_!?]+)["'']')
  if empty(l:match)
    return 0
  endif

  let l:controller = l:match[1]
  let l:action = l:match[2]
  let l:controller_path = s:project_root() . '/app/controllers/' . l:controller . '_controller.rb'

  if !filereadable(l:controller_path)
    return 0
  endif

  execute 'edit ' . fnameescape(fnamemodify(l:controller_path, ':p'))
  call search('\v^\s*def\s+' . escape(l:action, '\'), 'W')
  return 1
endfunction

function! s:definition_fallback(fallback_cmd) abort
  if s:jump_to_route_target()
    return
  endif

  call s:eruby_related_fallback(a:fallback_cmd)
endfunction

function! s:eruby_related_fallback(fallback_cmd) abort
  if &filetype !=# 'eruby'
    execute a:fallback_cmd
    return
  endif

  if s:jump_to_erb_partial()
    return
  endif

  let l:before = bufname('%')

  if exists(':R') == 2
    silent! execute 'R'
    if bufname('%') !=# l:before
      return
    endif
  endif

  if exists(':A') == 2
    silent! execute 'A'
    if bufname('%') !=# l:before
      return
    endif
  endif

  execute a:fallback_cmd
endfunction

function! s:lsp_or_fallback(kind, fallback_cmd) abort
  if !s:has_lsp_client()
    if a:kind ==# 'definition'
      call s:definition_fallback(a:fallback_cmd)
    else
      execute a:fallback_cmd
    endif
    return
  endif

  if a:kind ==# 'definition'
    if s:lsp_has_definition()
      lua vim.lsp.buf.definition()
    else
      call s:definition_fallback(a:fallback_cmd)
    endif
  elseif a:kind ==# 'hover'
    if s:lsp_has_hover()
      lua vim.lsp.buf.hover()
    else
      if a:fallback_cmd ==# 'grep_word_under_cursor'
        call s:grep_word_under_cursor()
      else
        execute a:fallback_cmd
      endif
    endif
  elseif a:kind ==# 'implementation'
    lua vim.lsp.buf.implementation()
  elseif a:kind ==# 'references'
    lua vim.lsp.buf.references()
  else
    execute a:fallback_cmd
  endif
endfunction

" ============================================================================
" Mappings
" ============================================================================

" Display toggles
nnoremap <F4> :call <SID>toggle_colorcolumn()<CR>
inoremap <F4> <C-o>:call <SID>toggle_colorcolumn()<CR>
cnoremap <F4> <C-c>:call <SID>toggle_colorcolumn()<CR>

nnoremap <F5> :set list!<CR>
inoremap <F5> <C-o>:set list!<CR>
cnoremap <F5> <C-c>:set list!<CR>

nnoremap <F9> :set hlsearch!<CR>
nnoremap <F10> :call <SID>toggle_spell()<CR>
inoremap <F10> <C-o>:call <SID>toggle_spell()<CR>
cnoremap <F10> <C-c>:call <SID>toggle_spell()<CR>

" Build and quickfix
nnoremap <C-B> :write<CR>:make<CR>:botright copen<CR>
nnoremap <C-[> :call <SID>lsp_or_fallback('implementation', 'lprev')<CR>
nnoremap <C-]> :call <SID>lsp_or_fallback('definition', 'lnext')<CR>
nnoremap <Leader>r :make run<CR>

" Core editor behavior
nnoremap <C-s> :update<CR>
inoremap <C-s> <Esc>:update<CR>
nnoremap <C-q> <C-c>:q<CR>
inoremap <C-q> <C-\><C-n>:q<CR>
nnoremap <C-x><C-x> <C-c>:q!<CR>

" Window movement
nnoremap <C-H> <C-w>h
inoremap <C-H> <C-\><C-n><C-w>h
nnoremap <C-J> <C-w>j
inoremap <C-J> <C-\><C-n><C-w>j
nnoremap <C-K> <C-w>k
inoremap <C-K> <C-\><C-n><C-w>k
nnoremap <C-L> <C-w>l
inoremap <C-L> <C-\><C-n><C-w>l

" Split and tab management
nnoremap <leader>v :vsplit<CR><C-w>l
cnoremap <leader>v <C-c>:vsplit<CR><C-w>l
nnoremap <leader>s :split<CR><C-w>j
cnoremap <leader>s <C-c>:split<CR><C-w>j

nnoremap <C-t> :tabedit<CR>
inoremap <C-t> <C-o>:tabedit<CR>
cnoremap <C-t> <C-c>:tabedit<CR>
nnoremap <Leader>1 :tabnext 1<CR>
nnoremap <Leader>2 :tabnext 2<CR>
nnoremap <Leader>3 :tabnext 3<CR>
nnoremap <Leader>4 :tabnext 4<CR>
nnoremap <Leader>5 :tabnext 5<CR>
nnoremap <Leader>6 :tabnext 6<CR>
nnoremap <Leader>7 :tabnext 7<CR>
nnoremap <Leader>8 :tabnext 8<CR>
nnoremap <Leader>9 :tabnext 9<CR>

" Text editing
vnoremap < <gv
vnoremap > >gv
xnoremap <leader>c Commentary
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" Plugin and search mappings
nmap <silent> <leader>d <Plug>DashSearch
nmap <Leader>o :TagbarToggle<CR>
nmap <Leader>n :NERDTreeToggle<CR><C-w>w
nmap <Leader>t :Files<CR>
nmap <Leader>h :History<CR>
nmap <Leader>w :Windows<CR>
nmap <C-N> :Tags<CR>

" LSP and completion mappings
nnoremap <leader>f :lua vim.lsp.buf.code_action()<CR>
vnoremap <leader>f :lua vim.lsp.buf.code_action()<CR>
inoremap <leader>f <C-o>:lua vim.lsp.buf.code_action()<CR>

" ============================================================================
" Search configuration
" ============================================================================

if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
  set grepformat=%f:%l:%c:%m,%f:%l:%m
  set switchbuf=useopen

  nnoremap K :call <SID>lsp_or_fallback('hover', 'grep_word_under_cursor')<CR>
  nnoremap <Leader>F :botright copen 8<CR>:set colorcolumn= nospell<CR>
endif

" ============================================================================
" Autocommands
" ============================================================================

augroup read_filetypes
  autocmd!
  autocmd BufRead,BufNewFile *.go set filetype=go
  autocmd FileType python setlocal tabstop=8 shiftwidth=4 softtabstop=4 expandtab
  autocmd FileType make setlocal noexpandtab tabstop=8 shiftwidth=8 softtabstop=0
  autocmd FileType plaintex setlocal spell spelllang=en_us
  autocmd FileType qf nnoremap <buffer> <CR> <CR><C-W>p
  autocmd FileType ruby nnoremap <buffer> <Leader>a :A<CR>
  autocmd FileType ruby nnoremap <buffer> <Leader>r :R<CR>
  autocmd FileType eruby nnoremap <buffer> <Leader>co :Econtroller<CR>
  autocmd FileType ruby nnoremap <buffer> <Leader>co :Econtroller<CR>
  autocmd FileType ruby nnoremap <buffer> <Leader>mo :Emodel<CR>
  autocmd FileType ruby nnoremap <buffer> <Leader>ev :Eview<CR>
  autocmd FileType ruby nnoremap <buffer> <Leader>ec :echom system('ctags -R --languages=ruby --exclude=.git --exclude=log . && ctags -R --languages=ruby --exclude=.git --exclude=log . $(bundle list --paths)')<CR>
  autocmd FileType python nmap <buffer> <silent> <leader>c <Plug>(pydocstring)
augroup END

augroup read_buffer_defaults
  autocmd!
  autocmd BufReadPost * call <SID>tabs_or_spaces()
  autocmd BufWritePre * call <SID>fix_whitespace()
  autocmd FileWritePre * call <SID>fix_whitespace()
  autocmd CompleteDone * if pumvisible() == 0 | pclose | endif
augroup END

augroup read_terminal
  autocmd!
  autocmd TermOpen * call <SID>setup_terminal_mappings()
  autocmd FileType fzf call <SID>setup_terminal_mappings()
augroup END

augroup read_formatters
  autocmd!
  autocmd BufWritePre *.py if exists(':Black') == 2 | Black | endif
  autocmd BufWritePre *.go lua vim.lsp.buf.format({ async = false })
augroup END

" ============================================================================
" Statusline tweaks
" ============================================================================

set statusline+=%#warningmsg#
set statusline+=%*
