" Personal (Read Sprabery) Customizations
"
" Bug identification :
" https://vi.stackexchange.com/questions/7252/gvim-cursor-jumps-all-over-the-place
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
" let Vundle manage Vundle
" required!

" Selection of which python bin to use for plugins
if filereadable("/Users/read/workspace/virtenvs/neovim/bin/python")
  let g:python_host_prog='/Users/read/workspace/virtenvs/neovim/bin/python'
endif

" Prefer python 3 if available
if filereadable("/Users/read/workspace/virtenvs/p3neovim/bin/python")
  let g:python_host_prog='/Users/read/workspace/virtenvs/p3neovim/bin/python'
  let g:python3_host_prog='/Users/read/workspace/virtenvs/p3neovim/bin/python'
endif

Plugin 'gmarik/vundle'

" Inspect white space
" https://stackoverflow.com/questions/1675688/make-vim-show-all-white-spaces-as-a-character
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
set listchars+=space:␣
noremap <F5> :set list!<CR>
inoremap <F5> <C-o>:set list!<CR>
cnoremap <F5> <C-c>:set list!<CR>

" :syntax on
:syntax enable
:set tabstop=4
set cindent
set smartindent
set autoindent
set expandtab
set shiftwidth=4

" Spacing in python
autocmd FileType python :set tabstop=8 expandtab shiftwidth=4 softtabstop=4
Bundle 'vim-python/python-syntax'
let g:python_highlight_all = 1

Bundle 'python/black'

if filereadable("/Users/read/workspace/virtenvs/black-vim/bin/activate")
    let g:black_virtualenv = '/Users/read/workspace/virtenvs/black-vim/'
endif

if filereadable("/home/read/workspace/virtenvs/black-vim/bin/activate")
    let g:black_virtualenv = '/home/read/workspace/virtenvs/black-vim/'
endif
autocmd BufWritePre *.py execute ':Black'

" Spacing for makefiles
autocmd FileType make :set tabstop=8 expandtab shiftwidth=4 softtabstop=4

" Hot keys for terminal mode
autocmd TermOpen * set nonumber nospell nocursorline
" Clear termianl output with <leader>k (reflects behavior of CMD-K on macOS)
autocmd TermOpen * cnoremap <leader>k :set scrollback=0<CR> :set scrollback=10000<CR>
autocmd TermOpen * vnoremap <leader>k :set scrollback=0<CR> :set scrollback=10000<CR>
autocmd TermOpen * nnoremap <leader>k :set scrollback=0<CR> :set scrollback=10000<CR>

autocmd TermOpen * xnoremap <ESC> <C-\><C-N>

function FirstPreProcLine()
  " let firstNonComment=index(getbufline(bufname("%"), 1, 250), 'v:val =~ "^\#"')
  execute "normal! gg/^#\<CR>"
  let firstNonComment=line(".")
  execute "normal! gg"
  return firstNonComment
endfunction

" Determine if tabs should be used instead of spaces for current file.
" https://unix.stackexchange.com/questions/63196/in-vim-how-can-i-automatically-determine-whether-to-use-spaces-or-tabs-for-inde
function TabsOrSpaces()
    " Determines whether to use spaces or tabs on the current buffer.
    if getfsize(bufname("%")) > 256000
        " File is very large, just use the default.
        return
    endif
    let startLine=1
    if &filetype ==# "cpp"
      let startLine = FirstPreProcLine()
    endif

    if &filetype ==# "c"
      let startLine = FirstPreProcLine()
    endif

    let numTabs=len(filter(getbufline(bufname("%"), startLine, 1000), 'v:val =~ "^\\t"'))
    let numSpaces=len(filter(getbufline(bufname("%"), startLine, 1000), 'v:val =~ "^ "'))

    if numTabs > numSpaces
        setlocal noexpandtab
    endif
endfunction

" Call the function after opening a buffer
autocmd BufReadPost * call TabsOrSpaces()

" set textwidth=80
function ToggleColorColumn()
  if &colorcolumn ==# 81
    :set colorcolumn=0
  else
    :set colorcolumn=81
  endif
endfunction


call ToggleColorColumn()

noremap <F4> :call ToggleColorColumn()<CR>
inoremap <F4> :call ToggleColorColumn()<CR>
cnoremap <F4> :call ToggleColorColumn()<CR>


let lspell = 1
function ToggleSpell()
    if g:lspell == 0
        :set spell
        let g:lspell = 1
    else
        :set nospell
        let g:lspell = 0
    endif
endfunction

" Disable spell check
noremap <F10> :set nospell<CR>
inoremap <F10> :set nospell<CR>
cnoremap <F10> :set nospell<CR>

noremap <F10> :call ToggleSpell()<CR>
inoremap <F10> :call ToggleSpell()<CR>
cnoremap <F10> :call ToggleSpell()<CR>

" Enabled line numbers
set nu

" Copy/Paste from system clipboard
" Makes all yank and put operations default to clipboard register
set clipboard+=unnamedplus
Bundle 'rsprabery/vim-tmux-clipboard'

" Same key stroke for navigation between vim splits and tmux panes.
" This relies on a change in tmux.conf as well.
" See: https://thoughtbot.com/blog/seamlessly-navigate-vim-and-tmux-splits
Bundle 'christoomey/vim-tmux-navigator'

" set paste
" http://stackoverflow.com/questions/28304137/youcompleteme-works-but-can-not-complete-using-tab
" This seems to be less necessary with nvim, which toggles paste for you
" automatically.
":set pastetoggle=<F10>
:let mapleader=","
set nocompatible               " be iMproved
filetype off                   " required!

" build / make keys
:map <C-B> :w<CR>:make<CR>:bot :copen<CR><CR>
:map <C-[> :lprev<CR>
:map <C-]> :lnext<CR>
:map <Leader>r :make run<CR>

" My Bundles here:
"
" original repos on github
" Git integtration
Bundle 'tpope/vim-fugitive'
" Activate with ,,gE or ,,w
Bundle 'Lokaltog/vim-easymotion'
" For html tags : CTRL-E: Look up special syntax
" Bundle 'rstacruz/sparkup' , {'rtp': 'vim/'}
" Some NoTes:
" CTRL-X CTRL-U for completion
" :A(alternate) and :R(related) for jumping between files
Bundle 'tpope/vim-rails.git'

Bundle 'rizzatti/dash.vim'
" Use dash's HUD mode.
let g:dash_activate=0
:nmap <silent> <leader>d <Plug>DashSearch

Bundle 'indentpython.vim'

Bundle 'VisIncr'
Plugin 'vim-ruby/vim-ruby'

set signcolumn=yes
"set omnifunc=
set hidden
Plugin 'prabirshrestha/asyncomplete.vim'
Plugin 'prabirshrestha/async.vim'
Plugin 'prabirshrestha/vim-lsp'
Plugin 'prabirshrestha/asyncomplete-lsp.vim'

nnoremap } :keepjumps :LspDefinition<CR>
vnoremap } :keepjumps :LspDefinition<CR>

nnoremap { :keepjumps :LspImplementation<CR>
vnoremap { :keepjumps :LspImplementation<CR>

nnoremap F :LspReferences<CR>

inoremap <leader>f :LspCodeAction<CR>
vnoremap <leader>f :LspCodeAction<CR>
nnoremap <leader>f :LspCodeAction<CR>

" let g:asyncomplete_log_file="/tmp/async_vim.log"
" let g:lsp_log_verbose = 1
" let g:lsp_log_file = expand('/tmp/vim-lsp.log')

if executable('clangd')
   au User lsp_setup call lsp#register_server({
      \ 'name': 'clangd',
      \ 'cmd': {server_info->['clangd']},
      \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp', 'cc'],
      \ })
endif
" if executable('ccls')
"    au User lsp_setup call lsp#register_server({
"       \ 'name': 'ccls',
"       \ 'cmd': {server_info->['ccls']},
"       \ 'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'compile_commands.json'))},
"       \ 'initialization_options': { 'cacheDirectory': '/tmp/ccls/cache' },
"       \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp', 'cc'],
"       \ })
" endif

if executable('solargraph')
    au User lsp_setup call lsp#register_server({
          \ 'name': 'solargraph',
          \ 'cmd': {server_info->[&shell, &shellcmdflag, 'solargraph stdio']},
          \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'Gemfile'))},
          \ 'whitelist': ['ruby', 'eruby'],
          \ })
endif


if executable('/Users/read/workspace/virtenvs/p3neovim/bin/pyls')
    au User lsp_setup call lsp#register_server({
          \ 'name': 'pyls',
          \ 'cmd': {server_info->['/Users/read/workspace/virtenvs/p3neovim/bin/pyls']},
          \ 'whitelist': ['python'],
          \ })
else
    if executable('/Users/read/workspace/virtenvs/pylsp/bin/pyls')
        au User lsp_setup call lsp#register_server({
          \ 'name': 'pyls',
          \ 'cmd': {server_info->['/Users/read/workspace/virtenvs/pylsp/bin/pyls']},
          \ 'whitelist': ['python'],
          \ })
    endif
endif

if executable('/Users/read/brew/bin/bash-language-server')
  au User lsp_setup call lsp#register_server({
        \ 'name': 'bash-language-server',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, '/Users/read/brew/bin/bash-language-server start']},
        \ 'whitelist': ['sh'],
        \ })
endif

au BufRead,BufNewFile *.go set filetype=go
set rtp+=$GOROOT/misc/vim
if executable('gopls')

    au User lsp_setup call lsp#register_server({
        \ 'name': 'gopls',
        \ 'cmd': {server_info->['gopls']},
        \ 'whitelist': ['go'],
        \ })

    " autocmd FileType go autocmd BufWritePost :LspDocumentFormat<CR>
    " autocmd FileType go autocmd FileWritePost :LspDocumentFormat<CR>
    " autocmd FileType go autocmd FileAppendPost :LspDocumentFormat<CR>

    autocmd BufWritePre *.go execute "LspDocumentFormat"

endif


let g:lsp_diagnostics_enabled = 1
let g:lsp_signs_enabled = 1         " enable signs
let g:lsp_diagnostics_echo_cursor = 1 " enable echo under cursor when in normal mode
let g:lsp_signs_warning = {'text': '!!'}
let g:lsp_signs_error = {'text': '✗'}
let g:lsp_signs_hint = {'text': 'H'}
let g:lsp_virtual_text_enabled = 0
" Keep focus on current window, not the preview window / pane
let g:lsp_preview_keep_focus=1
" Put preview information in a float / hover over / pop-up (neovim 4+)
let g:lsp_preview_float = 1
let g:lsp_preview_autoclose = 0
let g:lsp_preview_max_height = -1
let g:lsp_signature_help_enabled = 0
" Don't edit text
let g:lsp_text_edit_enabled = 0

set completeopt-=preview
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

inoremap <expr> <Tab> pumvisible()? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible()? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <CR> pumvisible()? "\<C-y>" : "\<CR>"
imap <c-space> <Plug>(asyncomplete_force_refresh)

" Plugin 'junegunn/vim-easy-align'

" Git Gutter
" [c -> prev hunk
" ]c -> next hunk
Plugin 'airblade/vim-gitgutter'
let g:gitgutter_map_keys = 0
" nmap ]c <Plug>GitGutterNextHunk
" nmap [c <Plug>GitGutterPrevHunk


"
" Brief help
" :BundleList          - list configured bundles
" :BundleInstall(!)    - install(update) bundles
" :BundleSearch(!) foo - search(or refresh cache first) for foo
" :BundleClean(!)      - confirm(or auto-approve) removal of unused bundles
"
" see :h vundle for more details or wiki for FAQ
" NOTE: comments after Bundle command are not allowed..

" Spell checking
autocmd FileType plaintex setlocal spell spelllang=en_us

autocmd FileType ruby nmap <Leader>a :A<CR>
autocmd FileType ruby nmap <Leader>r :R<CR>
autocmd FileType ruby nmap <Leader>co :Econtroller<CR>
autocmd FileType ruby nmap <Leader>mo :Emodel<CR>
autocmd FileType ruby nmap <Leader>vi :Eview<CR>
autocmd FileType ruby nmap <Leader>ec :echom system("ctags -R --languages=ruby --exclude=.git --exclude=log . && ctags -R --languages=ruby --exclude=.git --exclude=log . $(bundle list --paths)")<CR>

" auto read changes from disk
" set autoread
" :nnoremap <Leader>T "=strftime("%c")<CR>P<C-f>

" Start interactive EasyAlign in visual mode (e.g. vipga)
 xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
Plugin 'vim-airline/vim-airline'
let g:airline_theme='light'
let g:airline#extensions#branch#enabled = 0
let g:airline#extensions#hunks#enabled = 0
let g:airline#extensions#whitespace#enabled = 0
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'
Plugin 'majutsushi/tagbar'
Plugin 'heavenshell/vim-pydocstring'
nmap <silent> <C-_> <Plug>(pydocstring)
autocmd FileType python nmap <silent> <leader>c <Plug>(pydocstring)

" Remove unwanted whitespace at the end of lines when saving a file
function FixWhitespace()
  let save_pos = getcurpos()
  " let save_pos[2] -= 1
  %s/\s\+$//e
  call setpos('.', save_pos)
endfunction

autocmd FileType * autocmd BufWritePre  <buffer> :call FixWhitespace()
autocmd FileType * autocmd FileWritePre <buffer> :call FixWhitespace()

nmap <Leader>o :TagbarToggle<CR>
set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

Plugin 'scrooloose/nerdtree'
map <Leader>n :NERDTreeToggle<CR><C-W>w

map <Leader>t :Files<CR>
map <Leader>h :History<CR>
map <Leader>w :Windows<CR>

" ************* START Hilight Management *********************
" Toggle highlight state with F9
let hlstate=1
nnoremap <F9> :if (hlstate == 0) \| nohlsearch \| else \| set hlsearch \| endif \| let hlstate=1-hlstate<CR>
" ************* END Hilight Management ***********************


" ************* START CTRL-XYZ Editor Behavior ***************
" CTRL-S for saving
" map  <C-s> <C-\><C-N>:update<CR>
" imap  <C-s> <C-\><C-N>:update<CR>
map  <C-s> :update<CR>
imap  <C-s> <ESC>:update<CR>
" CTLR-q for quiting
map <C-q> <C-C>:q<CR>
imap <C-q> <C-\><C-N>:q<CR>
" CTRL-x for force quit (without saving)
map <C-x><C-x> <C-C>:q!<CR>
" ************* END CTRL-XYZ Editor Behavior *****************

" ************ START - Window-Management *********************
" Changing Windows with jkhl (Ctrl-(J/K/H/L)
map <C-H> <C-C><C-W>h
imap <C-H> <C-\><C-N><C-C><C-W>h<CR>

map <C-L> <C-C><C-W>l
imap <C-L> <C-\><C-N><C-C><C-W>l<CR>

map <C-J> <C-C><C-W>j
imap <C-J> <C-\><C-N><C-C><C-W>j<CR>

map <C-K> <C-C><C-W>k
imap <C-K> <C-\><C-N><C-C><C-W>k<CR>
" ************ END - Window-Management ***********************

" Keep visual selection selected when tabbing and un-tabbing
vnoremap < <gv
vnoremap > >gv

" Use the Silver Searcher (if installed)
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
nmap <C-N> :Tags<CR>
" nmap <C-M> :BTags<CR>

if executable('/opt/homebrew/bin/fzf')
  set rtp+=/opt/homebrew/opt/fzf
endif

if executable('/usr/bin/fzf')
  set rtp+=/usr/bin/fzf
endif

if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " bind K to grep word under cursor (opens in quickfix)
  nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:bot :cw <CR><CR>:set colorcolumn=0 nospell<CR>

  " Open quick fix selections in new tab (or use existint if already open)
  set switchbuf+=newtab

  " Easily open QuickSearch window with ,-F after grep!
  nmap <Leader>F :bot :cw<CR><CR>:set colorcolumn=0 nospell<CR>
endif

" ******* START Keys Bindings for Finding C/C++ Items *********
let lspStatus=-1
function EnableCtags(serverName)
    echo "things"
    sleep 500m
    " Match end will return -1 if no match is found.
    " This function always returns "running" at the end if there is a LSP
    " server running and "not running" if there isn't.
    let lspStatus=matchend(lsp#get_server_status(),"&a:serverName not running")
    if lspStatus > 0
        autocmd FileType c,cpp nmap <Leader>] "zyiw:exe "cs f t struct <C-r>z {"<CR>
        " Bundle "joe-skb7/cscope-maps"
    end
    echo lspStatus
endfunction
" autocmd FileType c,cpp :call EnableCtags('ccls')

" Better highlighting for C++
Bundle 'octol/vim-cpp-enhanced-highlight'

" ******* END Keys Bindings for Finding C/C++ Items *********

" ******************** Tab Config *****************************
noremap <C-t> :tabedit<CR>
inoremap <C-t> <C-o>:tabedit<CR>
cnoremap <C-t> <C-c>:tabedit<CR>

nmap <Leader>1 :tabnext 1<CR>
nmap <Leader>2 :tabnext 2<CR>
nmap <Leader>3 :tabnext 3<CR>
nmap <Leader>4 :tabnext 4<CR>
nmap <Leader>5 :tabnext 5<CR>
nmap <Leader>6 :tabnext 6<CR>
nmap <Leader>7 :tabnext 7<CR>
nmap <Leader>8 :tabnext 8<CR>
nmap <Leader>9 :tabnext 9<CR>
" **************** END Tab Config *****************************

" **************** Commenting *********************************
Bundle 'tpope/vim-commentary'
xnoremap <leader>c Commentary
" **************** END Commenting *****************************

" ****************** Crystal Lang *****************************
Bundle 'rhysd/vim-crystal'
" Run crystal format when saving the file
let g:crystal_auto_format = 1
" ****************** END Crystal Lang *************************

 Plugin 'keith/xcconfig.vim'
filetype plugin indent on     " required!

" **************** Keys for Splits *********************************
noremap <leader>v :vsp<CR><C-W>l<CR>
cnoremap <leader>v :vsp<CR><C-W>l<CR>

noremap <leader>s :sp<CR><C-W>j<CR>
cnoremap <leader>s :sp<CR><C-W>j<CR>
" **************** Keys for Splits *********************************

" *************************** Snippets **************************************
" Track the engine.
" Bundle 'SirVer/ultisnips'
" let g:UltiSnipsExpandTrigger="<c-e>"
" let g:UltiSnipsJumpForwardTrigger="<S-b>"
" let g:UltiSnipsJumpBackwardTrigger="<S-z>"

" ************************** End Snippets ***********************************

" Enable mouse support
:set mouse=a

" Enable syntax  - this allows spell check to run only on the comments
:se spell

" Load all plugins now.
" " Plugins need to be added to runtimepath before helptags can be generated.
packloadall
" " Load all of the helptags now, after plugins have been loaded.
" " All messages and errors will be ignored.
silent! helptags ALL

" *************** Custom Colors *******************************
" **** These must come after setting the theme above.
" *************************************************************

" Put a line under the active cursor line
set cursorline
" Enable real colors
set termguicolors

Bundle 'morhetz/gruvbox'
function! Carousel()
  for theme in split(globpath(&runtimepath, 'colors/*.vim'), '\n')
    let t = fnamemodify(theme, ':t:r')
    try
      execute 'colorscheme '.t
      redraw!
      echo t
    catch
    finally
    endtry
    sleep 1
    redraw!
  endfor
endfunction

Bundle 'vim-airline/vim-airline-themes'

" map <silent> <Leader>tc :call Carousel()<CR>

let g:gruvbox_italic=1
let g:gruvbox_undercurl=1
let g:gruvbox_contrast_light='hard'
let g:gruvbox_number_column='bg1'
let g:gruvbox_color_column='bg1'
let g:gruvbox_guisp_fallback='bg4'
" colorscheme gruvbox

Plugin 'tomasiser/vim-code-dark'
colorscheme codedark
let g:airline_theme = 'codedark'

" highlight CursorLine guibg=223 gui=NONE
" Change the default background, but keep airline the same.
" TODO: Make airline text stay white when making the background lighter.
" set background=light
" highlight Normal guibg=230
" let g:airline_theme='gruvbox'

" Change tab bar colors
"    TabLineFill is the middle (so the fg doesn't have anything to display)
highlight TabLineFill guifg=#665c54 guibg=#bdae93
highlight TabLineSel guifg=#282828 guibg=#d5c4a1
" guibg=#b57614 "yellow"
highlight TabLine guifg=#7c6f64 guibg=#d5c4a1
" guibg=#b57614 "yellow"

highlight link LspErrorText GruvboxRedSign " requires gruvbox
" ****************** END Color Config *************************

if filereadable("/Users/read/.config/nvim/local.vim")
  source ~/.config/nvim/local.vim
endif


xnoremap <leader>g :let @+=@%<CR>
inoremap <leader>g :let @+=@%<CR>
vnoremap <leader>g :let @+=@%<CR>
cnoremap <leader>g :let @+=@%<CR>
nnoremap <leader>g :let @+=@%<CR>
