" Personal (Read Sprabery) Customizations
:syntax on
:set tabstop=2
set cindent
set smartindent
set autoindent
set expandtab
set shiftwidth=2

" Spacing in python
autocmd FileType python :set tabstop=8 expandtab shiftwidth=4 softtabstop=4

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

    let numTabs=len(filter(getbufline(bufname("%"), startLine, 250), 'v:val =~ "^\\t"'))
    let numSpaces=len(filter(getbufline(bufname("%"), startLine, 250), 'v:val =~ "^ "'))

    if numTabs > numSpaces
        setlocal noexpandtab
    endif
endfunction

" Call the function after opening a buffer
autocmd BufReadPost * call TabsOrSpaces()

" Inspect white space
" https://stackoverflow.com/questions/1675688/make-vim-show-all-white-spaces-as-a-character
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
set listchars+=space:␣
noremap <F5> :set list!<CR>
inoremap <F5> <C-o>:set list!<CR>
cnoremap <F5> <C-c>:set list!<CR>

" set textwidth=80
highlight ColorColumn ctermbg=gray
set colorcolumn=81
set nu
" set paste
" http://stackoverflow.com/questions/28304137/youcompleteme-works-but-can-not-complete-using-tab
:set pastetoggle=<F10>
:let mapleader=","
imap <Leader>E :FufCoverageFile
set nocompatible               " be iMproved
filetype off                   " required!

" build keys
:map <C-B> :w<CR>:make<CR><CR>
:map <C-v> :lprev<CR>
:map <C-n> :lnext<CR>
:map <C-x> :make run<CR>

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let g:jedi#popup_on_dot = 0 

" No autofill on .
inoremap <C-X><C-O> <C-X><C-O><C-P> 
" let Vundle manage Vundle
" required! 
Bundle 'gmarik/vundle'

" My Bundles here:
"
" original repos on github
" Git integtration
Bundle 'tpope/vim-fugitive'
" Activate with ,,gE or ,,w
Bundle 'Lokaltog/vim-easymotion'
" For html tags : CTRL-E: Look up special syntax
" Bundle 'rstacruz/sparkup' , {'rtp': 'vim/'}
" Pretty obvious....
" Some NoTes:
" CTRL-X CTRL-U for completion
" :A(alternate) and :R(related) for jumping between files
Bundle 'tpope/vim-rails.git'

" non github repos
" Bundle 'git://git.wincent.com/command-t.git'

" Some python things, but may be adding spaces wrong? (In all files)
" Bundle 'https://github.com/davidhalter/jedi-vim.git'

" tab to complete snipit, check installation diretory
" Bundle "snipMate"
" ...
Bundle 'VisIncr'
Plugin 'flazz/vim-colorschemes'
Plugin 'vim-ruby/vim-ruby'
Plugin 'Valloric/YouCompleteMe'
Plugin 'junegunn/vim-easy-align'
Plugin 'airblade/vim-gitgutter'

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

filetype plugin indent on     " required!
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
set autoread
" :nnoremap <Leader>T "=strftime("%c")<CR>P<C-f>

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'majutsushi/tagbar'
Plugin 'heavenshell/vim-pydocstring'
nmap <silent> <C-_> <Plug>(pydocstring)
autocmd FileType python nmap <silent> <C-d> <Plug>(pydocstring)

nmap <Leader>o :TagbarToggle<CR>
set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" Plugin 'vim-syntastic/syntastic'
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

Plugin 'scrooloose/nerdtree'
map <Leader>n :NERDTreeToggle<CR><C-W>w
map <Leader>t :CtrlPMixed<CR>
" autocmd FileType c nnoremap K :Man <cword>

map <C-q> <C-C>:q<CR>
imap <C-q> <C-\><C-N>:q<CR>

map <C-x> <C-C>:q!<CR>

let hlstate=0
nnoremap <F9> :if (hlstate == 0) \| nohlsearch \| else \| set hlsearch \| endif \| let hlstate=1-hlstate<cr>

map  <C-s>             <C-\><C-N>:update<CR>
imap  <C-s>            <C-\><C-N>:update<CR>
"noremap  <C-s>         <C-\><C-N>:update<CR>
"vnoremap <C-s>         <C-\><C-N>:update<CR>
"inoremap <C-s>         <C-\><C-N><C-O>:update<CR>
"

map <C-H> <C-C><C-W>h
imap <C-H> <C-\><C-N><C-C><C-W>h<CR>

map <C-L> <C-C><C-W>l
imap <C-L> <C-\><C-N><C-C><C-W>l<CR>

" Keep visual selection selected when tabbing and un-tabbing
vnoremap < <gv
vnoremap > >gv

" Selection of which python bin to use for plugins
let g:ycm_python_binary_path = '/usr/bin/python'

Bundle "rdnetto/YCM-Generator"
Bundle "joe-skb7/cscope-maps"

" ctrlp config
Bundle 'ctrlpvim/ctrlp.vim'
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.o     " MacOSX/Linux
let g:ctrlp_use_caching = 1
let g:ctrlp_clear_cache_on_exit = 0

if isdirectory("/dev/shm/")
  let g:ctrlp_cache_dir = "/dev/shm/cache/ctrlp"
endif 

autocmd FileType c nmap <Leader>] "zyiw:exe "cs f t struct <C-r>z {"<CR>

Bundle 'chriskempson/base16-vim'

" colorscheme BlackSea
" let base16colorspace=256
" colorscheme base16-twilight
colorscheme 256-jungle

" The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

if executable('matcher')
	let g:ctrlp_match_func = { 'match': 'GoodMatch' }
 
	function! GoodMatch(items, str, limit, mmode, ispath, crfile, regex)
 
	  " Create a cache file if not yet exists
	  let cachefile = ctrlp#utils#cachedir().'/matcher.cache'
	  if !( filereadable(cachefile) && a:items == readfile(cachefile) )
		call writefile(a:items, cachefile)
	  endif
	  if !filereadable(cachefile)
		return []
	  endif
 
	  " a:mmode is currently ignored. In the future, we should probably do
	  " something about that. the matcher behaves like "full-line".
	  let cmd = 'matcher --limit '.a:limit.' --manifest '.cachefile.' '
	  if !( exists('g:ctrlp_dotfiles') && g:ctrlp_dotfiles )
		let cmd = cmd.'--no-dotfiles '
	  endif
	  let cmd = cmd.a:str
 
	  return split(system(cmd), "\n")

	endfunction
end
