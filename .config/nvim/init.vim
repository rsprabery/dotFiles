" Personal (Read Sprabery) Customizations
"
" Bug identification :
" https://vi.stackexchange.com/questions/7252/gvim-cursor-jumps-all-over-the-place
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
" let Vundle manage Vundle
" required!
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

" Spacing for makefiles
autocmd FileType make :set tabstop=8 expandtab shiftwidth=4 softtabstop=4

" Hot keys for terminal mode
autocmd TermOpen * set nonumber nospell nocursorline
" Clear termianl output with <leader>k (reflects behavior of CMD-K on macOS)
autocmd TermOpen * cnoremap <leader>k :set scrollback=0<CR> :set scrollback=10000<CR>
autocmd TermOpen * vnoremap <leader>k :set scrollback=0<CR> :set scrollback=10000<CR>
autocmd TermOpen * nnoremap <leader>k :set scrollback=0<CR> :set scrollback=10000<CR>

autocmd TermOpen * xnoremap <ESC> <C-\><C-N>

" Put a line under the active cursor line
:set cursorline

function FirstPreProcLine()
  " let firstNonComment=index(getbufline(bufname("%"), 1, 250), 'v:val =~ "^\#"')
  execute "normal! gg/^#\<cr>"
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

" No autofill on .
" inoremap <C-X><C-O> <C-X><C-O><C-P>

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

Bundle 'VisIncr'
Plugin 'flazz/vim-colorschemes'
Plugin 'vim-ruby/vim-ruby'

" Selection of which python bin to use for plugins
" let g:ycm_python_binary_path = '/usr/bin/python'
" if filereadable("~/.virtualenvs/nvim/bin/python")
"   let g:ycm_python_binary_path = '~/.virtualenvs/nvim/bin/python'
" endif
if filereadable("~/workspace/virtenvs/neovim/bin/python")
  let g:python_host_prog='~/workspace/virtenvs/neovim/bin/python'
endif

" Plugin 'autozimu/LanguageClient-neovim'
" set runtimepath+=~/.vim-plugins/LanguageClient-neovim

" let g:LanguageClient_serverCommands = {
" \ 'cpp': ['/Users/read/brew/bin/cquery',
" \ '--log-file=/tmp/cq.log',
" \ '--init={"cacheDirectory":"/tmp/cquery/cache/"}'],
" \ 'c': ['/Users/read/brew/bin/cquery',
" \ '--log-file=/tmp/cq.log',
" \ '--init={"cacheDirectory":"/tmp/cquery/cache/"}'],
" \ 'h': ['/Users/read/brew/bin/cquery',
" \ '--log-file=/tmp/cq.log',
" \ '--init={"cacheDirectory":"/tmp/cquery/cache/"}'],
" \ }

" nnoremap { :keepjumps :call LanguageClient#textDocument_implementation()<CR>
" vnoremap { :keepjumps :call LanguageClient#textDocument_implementation()<CR>
" nnoremap } :keepjumps :call LanguageClient#textDocument_definition()<CR>
" vnoremap } :keepjump :call LanguageClient#textDocument_definition()<CR>
" nnoremap F :call LanguageClient#textDocument_references()<CR>
" inoremap <leader>f :call LanguageClient#textDocument_codeAction()<CR>
" vnoremap <leader>f :call LanguageClient#textDocument_codeAction()<CR>
" nnoremap <leader>f :call LanguageClient#textDocument_codeAction()<CR>
" " set hidden
" let g:LanguageClient_selectionUI="location-list"
" set signcolumn=yes


set signcolumn=yes
set omnifunc=
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

let g:lsp_diagnostics_echo_cursor = 1

if executable('ccls')
   au User lsp_setup call lsp#register_server({
      \ 'name': 'ccls',
      \ 'cmd': {server_info->['ccls']},
      \ 'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'compile_commands.json'))},
      \ 'initialization_options': { 'cacheDirectory': '/tmp/ccls/cache' },
      \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp', 'cc'],
      \ })
endif

if executable('/Users/read/workspace/virtenvs/pylsp/bin/pyls')
    au User lsp_setup call lsp#register_server({
      \ 'name': 'pyls',
      \ 'cmd': {server_info->['/Users/read/workspace/virtenvs/pylsp/bin/pyls']},
      \ 'whitelist': ['python'],
      \ })
endif

if executable('/Users/read/brew/bin/bash-language-server')
  au User lsp_setup call lsp#register_server({
        \ 'name': 'bash-language-server',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, '/Users/read/brew/bin/bash-language-server start']},
        \ 'whitelist': ['sh'],
        \ })
endif

let g:lsp_signs_enabled = 1         " enable signs
let g:lsp_diagnostics_echo_cursor = 1 " enable echo under cursor when in normal mode
let g:lsp_signs_error = {'text': '✗'}

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<cr>"
imap <c-space> <Plug>(asyncomplete_force_refresh)

" Plugin 'junegunn/vim-easy-align'

" Git Gutter
" [c -> prev hunk
" ]c -> next hunk
Plugin 'airblade/vim-gitgutter'
let g:gitgutter_map_keys = 0
" nmap ]c <Plug>GitGutterNextHunk
" nmap [c <Plug>GitGutterPrevHunk

function! Carousel()
  for theme in split(globpath(&runtimepath, 'colors/*.vim'), '\n')
    let t = fnamemodify(theme, ':t:r')
    try
      execute 'colorscheme '.t
      echo t
    catch
    finally
    endtry
    sleep 4
    redraw
  endfor
endfunction

" map <silent> <Leader>tc :call Carousel()<cr>

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
Plugin 'vim-airline/vim-airline-themes'
let g:airline_theme='light'
let g:airline#extensions#branch#enabled = 0
let g:airline#extensions#hunks#enabled = 0
" let b:airline_whitespace_checks=[]
" let g:airline_section_warning = ["ycm_warning_count", "syntastic-warn"]
let g:airline#extensions#whitespace#enabled = 0
" let g:airline#extensions#whitespace#mixed_indent_algo = 2
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'
Plugin 'majutsushi/tagbar'
Plugin 'heavenshell/vim-pydocstring'
nmap <silent> <C-_> <Plug>(pydocstring)
autocmd FileType python nmap <silent> <leader>c <Plug>(pydocstring)

" Remove unwanted whitespace at the end of lines when saving a file
function FixWhitespace()
  let save_pos = getpos(".")
  %s/\s\+$//e
  call setpos('.', save_pos)
endfunction

autocmd FileType c,cpp,java,php,xcconfig,make,python,vim,tex,markdown,sh,zsh,bash,txt autocmd BufWritePre <buffer> :call FixWhitespace()
nmap <Leader>o :TagbarToggle<CR>
set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

Plugin 'scrooloose/nerdtree'
map <Leader>n :NERDTreeToggle<CR><C-W>w
" map <Leader>t :CtrlPMixed<CR>
map <Leader>t :Files<CR>
map <Leader>h :History<CR>
map <Leader>w :Windows<CR>
" autocmd FileType c nnoremap K :Man <cword>

" ************* START Hilight Management *********************
" Toggle highlight state with F9
let hlstate=1
nnoremap <F9> :if (hlstate == 0) \| nohlsearch \| else \| set hlsearch \| endif \| let hlstate=1-hlstate<cr>
" ************* END Hilight Management ***********************


" ************* START CTRL-XYZ Editor Behavior ***************
" CTRL-S for saving
map  <C-s>             <C-\><C-N>:update<CR>
imap  <C-s>            <C-\><C-N>:update<CR>
" CTLR-q for quiting
map <C-q> <C-C>:q<CR>
imap <C-q> <C-\><C-N>:q<CR>
" CTRL-x for force quit (without saving)
map <C-x> <C-C>:q!<CR>
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

" *************** ctrlp-config ********************************
" Bundle 'ctrlpvim/ctrlp.vim'
" Ignore temp files, object files, archives and vim swap files
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.o     " MacOSX/Linux
" Store search items in a cache
" let g:ctrlp_use_caching = 0
" let g:ctrlp_clear_cache_on_exit = 0

" let g:ctrlp_max_files = 0
" let g:ctrlp_max_depth = 0
" let g:ctrlp_mruf_max = 250

" Store the cache in ramdsik on Linux
" if isdirectory("/dev/shm/")
  " let g:ctrlp_cache_dir = "/dev/shm/cache/ctrlp"
" endif

" Use the Silver Searcher (if installed)
Plugin 'junegunn/fzf.vim'
set rtp+=/Users/read/brew/opt/fzf
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " bind K to grep word under cursor (opens in quickfix)
  nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:bot :cw <CR><CR>:set colorcolumn=0 nospell<CR>

  " Open quick fix selections in new tab (or use existint if already open)
  set switchbuf+=newtab

  " Easily open QuickSearch window with ,-F after grep!
  nmap <Leader>F :bot :cw<CR><CR>:set colorcolumn=0 nospell<CR>
endif

" Use matcher for ctrl-p if present on system.
" This handles fuzzy search. Still limited, but much better than ag.
" if executable('matcher')
" 	let g:ctrlp_match_func = { 'match': 'GoodMatch' }
"   let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:10,results:750000'

" 	function! GoodMatch(items, str, limit, mmode, ispath, crfile, regex)

" 	  " Create a cache file if not yet exists
" 	  let cachefile = ctrlp#utils#cachedir().'/matcher.cache'
" 	  if !( filereadable(cachefile) && a:items == readfile(cachefile) )
" 		call writefile(a:items, cachefile)
" 	  endif
" 	  if !filereadable(cachefile)
" 		return []
" 	  endif

" 	  " a:mmode is currently ignored. In the future, we should probably do
" 	  " something about that. the matcher behaves like "full-line".
" 	  let cmd = 'matcher --limit '.a:limit.' --manifest '.cachefile.' '
" 	  if !( exists('g:ctrlp_dotfiles') && g:ctrlp_dotfiles )
" 		let cmd = cmd.'--no-dotfiles '
" 	  endif
" 	  let cmd = cmd.a:str

" 	  return split(system(cmd), "\n")

"   endfunction
" end
" *************** END ctrlp-config ****************************

" ******* START Keys Bindings for Finding C/C++ Items *********
" autocmd FileType c nmap <Leader>] "zyiw:exe "cs f t struct <C-r>z {"<CR>
" Bundle "rdnetto/YCM-Generator"
" Bundle "joe-skb7/cscope-maps"
" ******* END Keys Bindings for Finding C/C++ Items *********

" ****************** Color Config *****************************
Bundle 'chriskempson/base16-vim'
" colorscheme 256-jungle
colorscheme  LightTan
" ****************** END Color Config *************************

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

 Plugin 'keith/xcconfig.vim'
filetype plugin indent on     " required!

" **************** Keys for Splits *********************************
noremap <leader>v :vsp<CR><C-W>l<CR>
cnoremap <leader>v :vsp<CR><C-W>l<CR>

noremap <leader>s :sp<CR><C-W>j<CR>
cnoremap <leader>s :sp<CR><C-W>j<CR>
" **************** Keys for Splits *********************************

" **************** Livepreview for Markdown *********************************
" Plugin 'JamshedVesuna/vim-markdown-preview'


" *************************** Snippets **************************************
" Track the engine.
" Bundle 'SirVer/ultisnips'
" let g:UltiSnipsExpandTrigger="<tab>"
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
highlight ColorColumn ctermbg=LightYellow
hi Search cterm=NONE ctermfg=Cyan ctermbg=LightRed
highlight Visual ctermbg=LightMagenta
:hi CursorLine ctermbg=13 cterm=NONE

if filereadable("/Users/read/.config/nvim/local.vim")
  source ~/.config/nvim/local.vim
endif
