
" Show line numbers
set nu rnu
set mouse=a
" Replace tab characters with spaces
set expandtab

" Set spaces count for one tab
set tabstop=2

" Disable Arrow keys in Escape mode
" Highlight search results
set hlsearch

" Enable incremental search
set incsearch

" Enable code highlighting
execute pathogen#infect()
syntax on
filetype plugin indent on
" Automatically install vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" before call project#rc()
let g:project_enable_welcome = 1
" if you want the NERDTree integration.
let g:project_use_nerdtree = 1
set rtp+=~/.vim/plugged/vim-project/
call project#rc("~/Code")

source ~/www/prj.txt
" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
""Functions for Project Management
function! RemoveTextWidth(...) abort
  setlocal textwidth=0
endfunction
function! AddSpecToPath(tile) abort
  setlocal path+=spec
endfunction
call plug#begin('~/.vim/plugged')

" ---------------- < PLUGINS START > ---------------- 

" File Manager
Plug 'preservim/nerdtree' |
            \ Plug 'Xuyuanp/nerdtree-git-plugin' |
            \ Plug 'scrooloose/nerdtree-project-plugin' |
" Beautiful GUI for Vim
Plug 'morhetz/gruvbox'
"
" Auto-pairs for brackets and parentheses
Plug 'jiangmiao/auto-pairs'

" Git built-in commands and diff realtime support for Vim
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
"
" Unprecise search for the case when you don't know exact name
Plug 'kien/ctrlp.vim'

" Easy Motion - extremely cool thing
Plug 'easymotion/vim-easymotion'

" Generic C, JavaScript and Rust auto-completion; ctags
Plug 'Valloric/YouCompleteMe'

" PHP & Symfony Auto-Completion
Plug 'Shougo/vimproc.vim', {'do' : 'make'}
Plug 'm2mdas/phpcomplete-extended'
Plug 'm2mdas/phpcomplete-extended-symfony'

" Automatically add 'use' for classes under cursor
Plug 'arnaud-lb/vim-php-namespace'

" Display tags in a window, ordered by scope
Plug 'majutsushi/tagbar'

" Ultimate solution for snippets in Vim
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" Helper functions for creating php snippets
Plug 'sniphpets/sniphpets'

" PHP snippets for Symfony framework
Plug 'sniphpets/sniphpets-symfony'
"End orgine vimrc

Plug 'stephpy/vim-php-cs-fixer'

Plug 'evidens/vim-twig'

Plug 'gpanders/vim-oldfiles'

Plug 'ta-tikoma/php.easy.vim'
Plug 'amiorin/vim-project'
"
" Any valid git URL is allowed
Plug 'https://github.com/junegunn/vim-github-dashboard.git'


Plug 'bun913/min-todo.vim' 

" Plugin outside ~/.vim/plugged with post-update hook
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'benwainwright/fzf-project'
" ---------------- < / PLUGINS END > ---------------- 

" Initialize plugin system
call plug#end()


" Map NERDTree
let NERDTreeWinPos=1
map <C-n> :NERDTreeToggle<CR>

" Set dark gruvbox theme
colorscheme gruvbox
set background=dark

" Map easy-motions key
map <Leader> <Plug>(easymotion-prefix)
let g:mapleader=','

" Enable auto-completion for phpcomplete
autocmd FileType php setlocal omnifunc=phpcomplete_extended#CompletePHP

" Map tag bar to F8 key
nmap <F8> :TagbarToggle<CR>

" vim-php-namespace: Import classes or functions (add use statements)
function! IPhpInsertUse()
    call PhpInsertUse()
    call feedkeys('a',  'n')
endfunction
autocmd FileType php inoremap <Leader>u <Esc>:call IPhpInsertUse()<CR>
autocmd FileType php noremap <Leader>u :call PhpInsertUse()<CR>

" vim-php-namespace: Make class or function names fully qualified
function! IPhpExpandClass()
    call PhpExpandClass()
    call feedkeys('a', 'n')
endfunction
autocmd FileType php inoremap <Leader>e <Esc>:call IPhpExpandClass()<CR>
autocmd FileType php noremap <Leader>e :call PhpExpandClass()<CR>

" vim-php-namespace: sort existing use statements alphabetically
autocmd FileType php inoremap <Leader>z <Esc>:call PhpSortUse()<CR>
autocmd FileType php noremap <Leader>z :call PhpSortUse()<CR>

" ultisnips: Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<F4>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" ultisnips: If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"


"Chuyển đổi giữa các hộp kiểm chưa hoàn thành và đã đóng chế độ bình thường
nnoremap <C-x> :ToggleTask<CR>
"Tạo một nhiệm vụ mới trong chế độ chèn
imap <C-x> <ESC>:CreateTask<CR>A
"Lưu các nhiệm vụ đã hoàn thành 
nnoremap <A-x> :ArchiveTasks<CR>
"Đăng ký phím tắt để có thể mở tệp quản lý tác vụ ngay lập tức
nnoremap <Leader>t :tabe ~/todo.md<CR>
"Recent files
map <C-e> :Oldfiles<CR>
map <C-A-e> :cclose<CR>
let g:oldfiles_blacklist = ['.vim','sys']

" provide hjkl movements in Insert mode via the <Alt> modifier key
inoremap <A-h> <C-o>h
inoremap <A-j> <C-o>j
inoremap <A-k> <C-o>k
inoremap <A-l> <C-o>l

 " Create Blank Newlines and stay in Normal mode
nnoremap <silent> zj o<Esc>k
nnoremap <silent> zk O<Esc>j



