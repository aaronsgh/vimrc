" vimrc.vim - Extension of vim-sensible plugin with less sensible defaults.
" Maintainer:   Aaron Graham-Horowitz <aaron@aaronsgh.com>
" Version:      3.0

if exists("g:loaded_vimrc") || &cp
  finish
else
  let g:loaded_vimrc = 1
end

"" Basics

" Disable strange Vi defaults.
set nocompatible

" Turn on filetype plugins (:help filetype-plugin).
if has('autocmd')
  filetype plugin indent on
endif

" Enable syntax highlighting.
if has('syntax')
  syntax enable
endif

" Autoindent when starting new line, or using `o` or `O`.
set autoindent

" Allow backspace in insert mode.
set backspace=indent,eol,start

" Don't scan included files. The .tags file is more performant.
set complete-=i

" Use 'shiftwidth' when using `<Tab>` in front of a line.
" By default it's used only for shift commands (`<`, `>`).
set smarttab

" Disable octal format for number processing.
set nrformats-=octal

" Allow for mappings including `Esc`, while preserving
" zero timeout after pressing it manually.
set ttimeout
set ttimeoutlen=100

" Enable highlighted case-insensitive incremential search.
set incsearch

" Indent using two spaces.
set tabstop=2
set shiftwidth=2
set expandtab

" Always show window statuses, even if there's only one.
set laststatus=2

" Show the line and column number of the cursor position.
set ruler

" Show the size of block one selected in visual mode.
set showcmd

" Autocomplete commands using nice menu in place of window status.
" Enable `Ctrl-N` and `Ctrl-P` to scroll through matches.
set wildmenu

" When 'wrap' is on, display last line even if it doesn't fit.
set display+=lastline

" Force utf-8 encoding in GVim
if &encoding ==# 'latin1' && has('gui_running')
  set encoding=utf-8
endif

" Set default whitespace characters when using `:set list`
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+

" Delete comment character when joining commented lines
if v:version > 703 || v:version == 703 && has("patch541")
  set formatoptions+=j
endif

" Search upwards for tags file instead only locally
if has('path_extra')
  setglobal tags-=./tags tags^=./tags;
endif

" Reload unchanged files automatically.
set autoread

" Support all kind of EOLs by default.
set fileformats+=mac

" Increase history size to 1000 items.
set history=1000

" Allow for up to 50 opened tabs on Vim start.
set tabpagemax=50

" Always save upper case variables to viminfo file.
set viminfo^=!

" Enable swap, backup and undo files by default.
let s:dir = has('win32') ? '$APPDATA/Vim' : isdirectory($HOME.'/Library') ? '~/Library/Vim' : empty($XDG_DATA_HOME) ? '~/.local/share/vim' : '$XDG_DATA_HOME/vim'
let &directory = expand(s:dir) . '/swap//'
let &backupdir = expand(s:dir) . '/backup//'
let &undodir = expand(s:dir) . '/undo//'
set undofile

" Allow color schemes to do bright colors without forcing bold.
if &t_Co == 8 && $TERM !~# '^linux'
  set t_Co=16
endif


" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

" `Ctrl-U` in insert mode deletes a lot. Use `Ctrl-G` u to first break undo,
" so that you can undo `Ctrl-U` without undoing what you typed before it.
inoremap <C-U> <C-G>u<C-U>

" Avoid problems with fish shell
" ([issue](https://github.com/tpope/vim-sensible/issues/50)).
if &shell =~# 'fish$'
  set shell=/bin/bash
endif

"" Extras

" Keep flags when repeating last substitute command.
nnoremap & :&&<CR>
xnoremap & :&&<CR>

" Y yanks from the cursor to the end of line as expected. See :help Y.
nnoremap Y y$

" Automatically create directories for swap, backup and undo files.
if !isdirectory(expand(s:dir))
  call system("mkdir -p " . expand(s:dir) . "/{swap,backup,undo}")
end

" Highlight line under cursor. It helps with navigation.
set cursorline

" Keep 8 lines above or below the cursor when scrolling.
set scrolloff=8

" Keep 15 columns next to the cursor when scrolling horizontally.
set sidescroll=1
set sidescrolloff=15

" Set minimum window size to 79x5.
set winwidth=79
set winheight=5
set winminheight=5

" If opening buffer, search first in opened windows.
set switchbuf=usetab

" Hide buffers instead of asking if to save them.
set hidden

" Wrap lines by default
set wrap linebreak
set showbreak=" "

" Allow easy navigation between wrapped lines.
vnoremap j gj
vnoremap k gk
nnoremap j gj
nnoremap k gk

" For autocompletion, complete as much as you can.
set wildmode=longest,full

" Show line numbers on the sidebar.
set number

" Disable any annoying beeps on errors.
set noerrorbells
set visualbell
set t_vb=

" Don't parse modelines (google "vim modeline vulnerability").
set nomodeline

" Enable mouse for scrolling and window resizing.
set mouse=a

" Save up to 100 marks, enable capital marks.
set viminfo='100,f1

" Enable search highlighting.
set hlsearch

" Ignore case when searching.
set ignorecase

" Show mode in statusbar, not separately.
set noshowmode

" Don't ignore case when search has capital letter
" (although also don't ignore case by default).
set smartcase

" Use dash as word separator.
set iskeyword+=-

" Add gems.tags to files searched for tags.
set tags+=gems.tags

" Disable output, vcs, archive, rails, temp and backup files.
set wildignore+=*.o,*.out,*.obj,.git,*.rbc,*.rbo,*.class,.svn,*.gem
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz
set wildignore+=*/vendor/gems/*,*/vendor/cache/*,*/.bundle/*,*/.sass-cache/*
set wildignore+=*.swp,*~,._*

" Auto center on matched string.
noremap n nzz
noremap N Nzz

" Expand %% to path of current buffer in command mode.
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" Enable saving by `Ctrl-s`
nnoremap <C-s> :w<CR>
inoremap <C-s> <ESC>:w<CR>

" Use Q to intelligently close a window
" (if there are multiple windows into the same buffer)
" or kill the buffer entirely if it's the last window looking into that buffer.
function! CloseWindowOrKillBuffer()
  let number_of_windows_to_this_buffer = len(filter(range(1, winnr('$')), "winbufnr(v:val) == bufnr('%')"))
  if matchstr(expand("%"), 'NERD') == 'NERD'
    wincmd c
    return
  endif
  if number_of_windows_to_this_buffer > 1
    wincmd c
  else
    bdelete
  endif
endfunction
nnoremap <silent> Q :call CloseWindowOrKillBuffer()<CR>

" Set window title by default.
set title

" Always focus on splited window.
nnoremap <C-w>s <C-w>s<C-w>w
nnoremap <C-w>v <C-w>v<C-w>w

" Don't display the intro message on starting Vim.
set shortmess+=I

" Make sure pasting in visual mode doesn't replace paste buffer
function! RestoreRegister()
  let @" = s:restore_reg
  return ''
endfunction
function! s:Repl()
  let s:restore_reg = @"
  return "p@=RestoreRegister()\<cr>"
endfunction
vmap <silent> <expr> p <sid>Repl()

" Make a simple "search" text object.
" http://vim.wikia.com/wiki/Copy_or_change_search_hit
" It allows for replacing search matches with cs and then /././.
vnoremap <silent> s //e<C-r>=&selection=='exclusive'?'+1':''<CR><CR>
    \:<C-u>call histdel('search',-1)<Bar>let @/=histget('search',-1)<CR>gv
omap s :normal vs<CR>
