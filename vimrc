" Personal (Read Sprabery) Customizations
:syntax on
:set tabstop=2
set cindent
set smartindent
set autoindent
set expandtab
set tabstop=2
set shiftwidth=2
set nu
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
Bundle 'rstacruz/sparkup' , {'rtp': 'vim/'}
" Pretty obvious....
" Some NoTes:
" CTRL-X CTRL-U for completion
" :A(alternate) and :R(related) for jumping between files
Bundle 'tpope/vim-rails.git'

" non github repos
Bundle 'git://git.wincent.com/command-t.git'

" Some python things, but may be adding spaces wrong? (In all files)
" Bundle 'https://github.com/davidhalter/jedi-vim.git'

" tab to complete snipit, check installation diretory
Bundle "snipMate"
" ...
Bundle 'VisIncr'

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
