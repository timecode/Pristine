" Configuration

" Pathogen first

" execute pathogen#infect()

" Basic Settings

filetype plugin indent on
syntax on
" colo pablo
colorscheme spacegray

set shell=/bin/zsh
set guifont="Meslo LG M Regular for Powerline":h14
" set nocompatible
" set modelines=0
" set tabstop=4
" set shiftwidth=4
" set softtabstop=4
" set expandtab
set encoding=utf-8
" set scrolloff=3
" set autoindent
" set showmode
" set showcmd
" set hidden
" set wildmenu
" set wildmode=list:longest
" set visualbell
" set ttyfast
" set ruler
" set backspace=indent,eol,start
" set laststatus=2
" set noundofile
" nnoremap / /\v
" vnoremap / /\v
" set ignorecase
" set smartcase
" set gdefault
" set incsearch
" set showmatch
" set hlsearch
" nnoremap <leader><space> :noh<cr>
" nnoremap <tab> %
" vnoremap <tab> %
" set wrap
" set linebreak
" set nolist
" set formatoptions=qrn1

" Mappings and shortcuts

" Basics
inoremap jk <ESC>
" let mapleader = " "

" Config
" :set spell spelllang=en_us

" Arrows are unvimlike
" nnoremap <up> <nop>
" nnoremap <down> <nop>
" nnoremap <left> <nop>
" nnoremap <right> <nop>
" inoremap <up> <nop>
" inoremap <down> <nop>
" inoremap <left> <nop>
" inoremap <right> <nop>

" Disable the ESC key
" inoremap <esc> <NOP>

" Miscellaneous
" inoremap <F1> <ESC>
" nnoremap <F1> <ESC>
" vnoremap <F1> <ESC>
" au FocusLost * :wa
" vnoremap . :norm.<CR>

" Leader shortcuts
" nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>
" nnoremap <leader>a :Ack

" Control shortcuts
" nnoremap <C-h> <C-w>h
" nnoremap <C-j> <C-w>j
" nnoremap <C-k> <C-w>k
" nnoremap <C-l> <C-w>l

" NOTE: additions for Golang in vim
" install https://github.com/junegunn/vim-plug
" then invoke the following
" vim +PlugInstall +qa
" vim +GoInstallBinaries +qa
" We then modify this file with the following
call plug#begin('~/.vim/plugged')

Plug 'fatih/vim-go'

call plug#end()

filetype off
filetype plugin indent on

set number
set noswapfile
set noshowmode
set ts=2 sw=2 sts=2 et
set backspace=indent,eol,start

" Map <leader> to comma
let mapleader=","
let g:go_version_warning = 0

if has("autocmd")
  autocmd FileType go set ts=4 sw=4 sts=4 noet nolist autowrite
endif
