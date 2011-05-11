"-------------------------"
" vimrc for James Conerly "
"-------------------------"

" operational settings
syntax on                              " syntax on
filetype on                            " automatic file type detection
filetype plugin on                     " automatic file plugin detection

let mapleader=','
let maplocalleader=','                 " all my macros start with ,
let g:snips_author='James Conerly'     " For SnipMate plugin

set title                              " better terminal title
set nocompatible                       " vim defaults, not vi!
set hidden                             " allow editing multiple unsaved buffers
set more                               " the 'more' prompt
set autoread                           " watch for file changes by other programs
set visualbell                         " visual beep
set nobackup                           " don't produce *~ backup files
set noautowrite                        " don't automatically write on :next, etc
set wildmenu                           " : menu has tab completion, etc
set ruler                              " cursor location information
set list                               " visualize tabbs and spaces
set number                             " line numbers in lefthandmost column
set ignorecase                         " ignore case when performing searches
set hlsearch                           " Highlight search terms...
set incsearch                          " ...dynamically as they are typed.
set smartcase                          " case-sensitive only if there is a
                                       "   capital letter in the search expression
set encoding=utf-8                     " needed for special (wide) chars work
set fileencoding=utf-8                 " needed for special (wide) chars work
set shortmess=atI                      " stifle interruptive prompts
set scrolloff=5                        " keep at least 5 lines above/below cursor
set sidescrolloff=5                    " keep at least 5 columns l/r of cursor
set history=1000                       " remember the last 200 commands
set bg=dark                            " dark background settings
set dictionary=/usr/share/dict/words   " dict
set foldmethod=marker                  " fold code based on markers
set showbreak=…                        " ellipsis for line contuations
set wildmode=list:longest              " Make file/command completion useful
set backspace=indent,eol,start         " Intuitive backspacing in insert mode
set modelines=0                        " no modelines
                                       "   [http://www.guninski.com/vim1.html]

" fast saving
nmap <leader>w :w!<cr>
nmap <leader>W :wq!<cr>

" fast editing of the vimrc
nmap <leader>e :e! ~/.vim/vimrc<cr>

" duplicate line with the dup commented out
nmap <leader>C ,cyP

" take a vselect block and turn it into an eval{} block
vmap <leader>E S{Ieval <esc>%A; warn $@ if $@;<esc>

" perltidy helpers
nmap <leader>P :%!perltidy -q<cr>
vmap <leader>P !perltidy -q<cr>

" when vimrc is edited, reload it
"autocmd! bufwritepost vimrc source ~/.vim/vimrc

" simple wrapping macro for simple paragraph formatting
command! -nargs=* Wrap set wrap linebreak nolist

" see our tabs and spaces
set list listchars=tab:»·,trail:·,eol:¬

" shortcut to lookup and open files within the current tree
" of the file that's currently open.
cnoremap %% <C-R>=expand('%:h').'/'<CR>
map <leader>ew :e %%
map <leader>es :sp %%
map <leader>ev :vsp %%
map <leader>et :tabe %%

" for dealing with code folding blocks, i.e. saving them to disk so
" they are persistant between reads of the same file.
au BufWinLeave ?* mkview
au BufWinEnter ?* silent loadview

" press Space to turn off highlighting and clear any message already displayed
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>

" want to use 'par' for paragraph formatting if it's installed.
"
" options:
"    w - specify line length
"    r - repeat characters in bodiless lines
"    j - justifies text
"    e - remove ‘superflous’ lines
"    q - handle nested quotations in plaintext email
"
" TODO: add if/else block to check for this.
set formatprg=par\ -w70rjeq

" some helper key maps
map Y y$
map > :set paste<CR>i
map < :set nopaste<CR>
map ` :!perl -c %<CR>
map + :w<CR>:!clear && perl %<CR>
map ^ :TlistToggle<CR>
map T :NERDTreeToggle<CR>

" Shortcut to rapidly toggle `set list`
nmap <leader>l :set list!<CR>
nmap <leader>n :set number!<CR>
nmap <leader>i :set list! number!<CR>

highlight NonText guifg=#4a4a59
highlight SpecialKey guifg=#4a4a59

" only do this part when compiled with support for autocommands
if has("autocmd")
  " Enable file type detection
  filetype on

  " jump to the last position when reopening a file
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

  " Syntax of these languages is fussy over tabs Vs spaces
  autocmd FileType make setlocal ts=8 sts=8 sw=8 noexpandtab
  autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType perl setlocal ts=4 sts=4 sw=4 expandtab
  autocmd FileType erlang setlocal ts=2 sts=2 sw=2 expandtab

  " Customisations based on house-style (arbitrary)
  autocmd FileType html setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType css setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType javascript setlocal ts=4 sts=4 sw=4 noexpandtab

  autocmd BufNewFile,BufRead *.pl,*.pm,*.PL,*.t setfiletype perl
endif

" set tabstop, softtabstop and shiftwidth to the same value
command! -nargs=* Stab call Stab()
function! Stab()
  let l:tabstop = 1 * input('set tabstop = softtabstop = shiftwidth = ')
  if l:tabstop > 0
    let &l:sts = l:tabstop
    let &l:ts = l:tabstop
    let &l:sw = l:tabstop
  endif
  call SummarizeTabs()
endfunction

function! SummarizeTabs()
  try
    echohl ModeMsg
    echon 'tabstop='.&l:ts
    echon ' shiftwidth='.&l:sw
    echon ' softtabstop='.&l:sts
    if &l:et
      echon ' expandtab'
    else
      echon ' noexpandtab'
    end
  finally
    echohl None
  endtry
endfunction

""" eof vimrc


