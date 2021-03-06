" pathogen
call pathogen#infect()
" Set encoding
set encoding=utf-8
"manage buffers efectively
set hidden
"sintax highlighting
syntax enable
"row and column of the cursor
set ruler
" higlight current line
set cursorline
"see the actual mode
set showmode
"see the actual command
set showcmd
"always show tabs
set showtabline=2
"indent depending on the filetype
filetype plugin indent on
"colorscheme desert
let g:solarized_termtrans = 1
set background=dark
colorscheme solarized
"Enable extended % matching
runtime macros/matchit.vim
"Store temp files in a central spot
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
"set terminal title
set title
"no audible bell, just flash the screen
set visualbell
" Toggle paste mode while in insert mode with F12
set pastetoggle=<F12>
" start the scrolling three lines before the border
set scrolloff=3
" Don't add the comment prefix when I hit enter or o/O on a comment line.
set formatoptions-=or
" Open new split panes to right and bottom, which feels more natural than
" Vim’s default:
set splitbelow
set splitright

"""" STATUSLINE - based on https://github.com/christoomey/dotfiles/blob/master/vim/rcfiles/statusline#L54
set laststatus=2 " Always show the statusline
set statusline= " Clear the statusline for vimrc reloads

"define 3 custom highlight groups
hi User1 ctermbg=lightgray ctermfg=yellow guifg=orange guibg=#444444 cterm=bold gui=bold
hi User2 ctermbg=lightgray ctermfg=red guifg=#dc143c guibg=#444444 gui=none
hi User3 ctermbg=lightgray ctermfg=red guifg=#ffff00 guibg=#444444 gui=bold


set stl=%*                       " Normal statusline highlight
set stl+=%{InsertSpace()}        " Put a leading space in
set stl+=%2*                     " Red highlight
set stl+=%m                      " Modified flag
set stl+=%*                      " Normal 
set stl+=%t                      " Filename
set stl+=%1*                     " Yellow highlight
set stl+=%{HasPaste()}           " Red show paste
set stl+=%*                      " Return to normal stl hilight

set stl+=%r                      " Readonly flag
set stl+=%h                      " Help file flag
set stl+=\ %y                    " Filetype

set stl+=%=                      " Right align from here on
set stl+=\ \ Col:%c              " Column number
set stl+=\ \ Line:%l/%L          " Line # / total lines
set stl+=\ \ %P%{InsertSpace()}  " Single space buffer


function! InsertSpace()
    " For adding trailing spaces onto statusline
    return ' '
endfunction

function! HasPaste()
    if &paste
        return '[paste]'
    else
        return ''
    endif
endfunction

"""" END STATUSLINE

" Switch between the last two files
nnoremap <leader><leader> <c-^>

" Emacs-like beginning and end of line.
imap <C-e> <c-o>$
imap <C-a> <c-o>^
map <C-a>  <Home>
map <C-e>  <End>

" Make j & k linewise
" turn off linewise keys -- normally, the `j' and `k' keys move the cursor down
" one entire line. with line wrapping on, this can cause the cursor to actually
" skip a few lines on the screen because it's moving from line N to line N+1 in
" the file. I want this to act more visually -- I want `down' to mean the next
" line on the screen
map j gj
map k gk

" Now, don't use arrow keys
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>
imap <up> <nop>
imap <down> <nop>
imap <left> <nop>
imap <right> <nop>

" use w!! to sudo :w  a file that we opened without su privs
cmap w!! w !sudo tee % >/dev/null

"
" Visual {
set showmatch "Show matching brackets
set relativenumber
" }
" Searching {
set hlsearch                    " hilight searches, map below to clear
set incsearch                   " do incremental searching
set ignorecase                  " Case insensitive...
set smartcase                   " ...except if you use UCase
" }
"
" Indenting {
"autoindent
set autoindent
set smarttab
set tabstop=2
set shiftwidth=2
set shiftround
set softtabstop=2
set expandtab
set list listchars=tab:\ \ ,trail:·
" }
" make uses real tabs
au FileType make set noexpandtab

" Thorfile, Rakefile, Vagrantfile and Gemfile are Ruby
au BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,Thorfile,config.ru} set ft=ruby

" Remove trailing whitespace on save for ruby files.
au BufWritePre *.{rb,rake,js,coffee,haml,css,scss} :call StripTrailingWhitespaces()
function! StripTrailingWhitespaces()
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  call cursor(l, c)
endfun


let mapleader = ","

map <C-right> :tabn<CR>
map <C-l> :tabn<CR>
map <C-left> :tabp<CR>
map <C-h> :tabp<CR>
map <leader>z :tabedit<Space>
map <leader>m :CtrlP<CR>
map <leader>- :nohl<CR>

nmap <leader>p :set paste!<CR>:set paste?<CR>
nmap \n :setlocal number!<CR>:setlocal number?<CR>


nmap <leader>tu :Tunittest<CR>
nmap <leader>tm :Tmodel<CR>
nmap <leader>tc :Tcontroller<CR>
nmap <leader>tf :Tfunctionaltest<CR>

" testing without screen
map <Leader>o :w<CR> :call RunCurrentLineInTest()<CR>
map <Leader>t :w<CR> :call RunCurrentTest()<CR>

" Edit another file in the same directory as the current file
" uses expression to extract path from current file's path
map <Leader>e :e <C-R>=expand("%:p:h") . '/'<CR>
map <Leader>s :split <C-R>=expand("%:p:h") . '/'<CR>
map <Leader>v :vnew <C-R>=expand("%:p:h") . '/'<CR>

map <C-s> <esc>:w<CR>
imap <C-s> <esc>:w<CR>
map <C-t> <esc>:tabnew<CR>



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Test-running stuff
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! RunCurrentTest()
  let in_test_file = match(expand("%"), '\(.feature\|_spec.rb\|_test.rb\)$') != -1
  if in_test_file
    call SetTestFile()

    if match(expand('%'), '\.feature$') != -1
      call SetTestRunner("!cucumber")
      exec g:bjo_test_runner g:bjo_test_file
    elseif match(expand('%'), '_spec\.rb$') != -1
      call SetTestRunner("!s")
      exec g:bjo_test_runner g:bjo_test_file
    else
      call SetTestRunner("!ruby -Itest")
      exec g:bjo_test_runner g:bjo_test_file
    endif
  else
    exec g:bjo_test_runner g:bjo_test_file
  endif
endfunction

function! SetTestRunner(runner)
  let g:bjo_test_runner=a:runner
endfunction

function! RunCurrentLineInTest()
  let in_test_file = match(expand("%"), '\(.feature\|_spec.rb\|_test.rb\)$') != -1
  if in_test_file
    call SetTestFileWithLine()
  end

  exec "!s" g:bjo_test_file . ":" . g:bjo_test_file_line
endfunction

function! SetTestFile()
  let g:bjo_test_file=@%
endfunction

function! SetTestFileWithLine()
  let g:bjo_test_file=@%
  let g:bjo_test_file_line=line(".")
endfunction

function! CorrectTestRunner()
  if match(expand('%'), '\.feature$') != -1
    return "cucumber"
  elseif match(expand('%'), '_spec\.rb$') != -1
    return "s"
  else
    return "ruby"
  endif
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

