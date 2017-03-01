" Personal (Read Sprabery) Customizations
:syntax on
:set tabstop=2
set cindent
set smartindent
set autoindent
set expandtab
set tabstop=2
set shiftwidth=2
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

colorscheme BlackSea

" Spell checking
autocmd FileType plaintex setlocal spell spelllang=en_us

autocmd FileType ruby nmap <Leader>a :A<CR>
autocmd FileType ruby nmap <Leader>r :R<CR>
autocmd FileType ruby nmap <Leader>co :Econtroller<CR>
autocmd FileType ruby nmap <Leader>mo :Emodel<CR>
autocmd FileType ruby nmap <Leader>vi :Eview<CR>
autocmd FileType ruby nmap <Leader>ec :echom system("ctags -R --languages=ruby --exclude=.git --exclude=log . && ctags -R --languages=ruby --exclude=.git --exclude=log . $(bundle list --paths)")<CR>

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
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

Plugin 'vim-syntastic/syntastic'
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

" Spacing in python
autocmd FileType python :set tabstop=8 expandtab shiftwidth=4 softtabstop=4

" Selection of which python bin to use for plugins
let g:ycm_python_binary_path = '/usr/bin/python'

Bundle "rdnetto/YCM-Generator"
Bundle "joe-skb7/cscope-maps"

" ctrlp config
Bundle 'ctrlpvim/ctrlp.vim'
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.o     " MacOSX/Linux
let g:ctrlp_use_caching = 1
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_cache_dir = "/dev/shm/cache/ctrlp"

autocmd FileType c nmap <Leader>] "zyiw:exe "cs f t struct <C-r>z {"<CR>
