set rtp+=$POWERLINE_ROOT/powerline/bindings/vim/

call plug#begin('~/.vim/plugged')

" JAVASCRIPT
"
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'mlaursen/vim-react-snippets'

" GOLANG
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'godoctor/godoctor.vim', { 'do': ':GoDoctorInstall' }

" PYTHON
Plug 'honza/vim-snippets'

" RUST
Plug 'rust-lang/rust.vim'

" NERD tree will be loaded on the first invocation of NERDTreeToggle command
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }

Plug 'janko/vim-test'
Plug 'Valloric/YouCompleteMe'
Plug 'nanotech/jellybeans.vim'
Plug 'vim-syntastic/syntastic'
Plug 'airblade/vim-gitgutter'
Plug 'terryma/vim-multiple-cursors'
Plug 'kien/ctrlp.vim'
Plug 'w0rp/ale'
Plug 'honza/vim-snippets'
Plug 'majutsushi/tagbar'
Plug 'jiangmiao/auto-pairs'
Plug 'scrooloose/nerdcommenter'
Plug 'junegunn/goyo.vim'
Plug 'janko/vim-test'
Plug 'tpope/vim-dispatch'
Plug 'neomake/neomake'
Plug 'itchyny/lightline.vim'
Plug 'SirVer/ultisnips'
Plug 'prettier/vim-prettier', { 'do': 'yarn install', 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html'] }

call plug#end()

set rtp+=$POWERLINE_ROOT/powerline/bindings/vim/

set nocompatible | syn on
filetype off
syntax on
filetype plugin on
filetype plugin indent on

set t_Co=256
set t_ut=
set tabstop=2
set softtabstop=2
set expandtab
set shiftwidth=2
set number
set showcmd
set cursorline
set showmatch
set modeline
set foldenable
set foldlevelstart=10
set foldnestmax=10
set foldmethod=indent
set laststatus=2
set encoding=utf-8
set fileencoding=utf-8
set termencoding=utf-8
set backupcopy=yes
set backspace=indent,eol,start

silent! colorscheme jellybeans

highlight Normal ctermbg=NONE guibg=NONE
highlight NonText ctermbg=NONE guibg=NONE
highlight clear SignColumn
highlight LineNr ctermfg=NONE ctermbg=NONE

"Code Folding
nnoremap <space> za

let g:prettier#autoformat = 0
autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.yaml,*.html PrettierAsync

set backspace=indent,eol,start
  
let g:airline_powerline_fonts = 1

" make YCM compatible with UltiSnips (using supertab)
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'

" better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

" Testing
" these "Ctrl mappings" work well when Caps Lock is mapped to Ctrl
nmap <silent> t<C-n> :TestNearest<CR>
nmap <silent> t<C-f> :TestFile<CR>
nmap <silent> t<C-s> :TestSuite<CR>
nmap <silent> t<C-l> :TestLast<CR>
nmap <silent> t<C-g> :TestVisit<CR>
