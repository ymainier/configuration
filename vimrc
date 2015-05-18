""
"" Basic Setup
""

execute pathogen#infect()

set nocompatible    " Use vim, no vi defaults
set number          " Show line numbers
set ruler           " Show line and column number
set encoding=utf-8  " Set default encoding to UTF-8
set cursorline      " Highlight the current line
syntax enable       " Turn on syntax highlighting allowing local overrides
let mapleader = ","

""
"" Appearance
""

set background=dark
colorscheme solarized
if has('gui_running')
	set guifont=Monaco:h13
endif

""
"" Whitespace
""

set nowrap                      " don't wrap lines
set tabstop=4                   " a tab is four spaces
set shiftwidth=4                " an autoindent (with <<) is four spaces
set softtabstop=4
set noexpandtab                 " use tabs, no space
set list                        " Show invisible characters
set backspace=indent,eol,start  " backspace through everything in insert mode

""
"" List chars
""

set listchars=""           " Reset the listchars
set listchars=tab:\ \      " a tab should display as " ", trailing whitespace as "."
set listchars+=trail:.     " show trailing spaces as dots
set listchars+=extends:>   " The character to show in the last column when wrap is
" off and the line continues beyond the right of the screen
set listchars+=precedes:<  " The character to show in the last column when wrap is
" off and the line continues beyond the left of the screen

""
"" Searching
""

set hlsearch    " highlight matches
set incsearch   " incremental searching
set ignorecase  " searches are case insensitive...
set smartcase   " ... unless they contain at least one capital letter

""
"" Wild settings
""

set wildmode=list:longest,list:full

" Disable output and VCS files
set wildignore+=*.o,*.out,*.obj,.git,*.rbc,*.rbo,*.class,.svn,*.gem

" Disable archive files
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz

" Disable temp and backup files
set wildignore+=*.swp,*~,._*

""
"" Backup and swap files
""

set backupdir^=~/.vim/_backup// " where to put backup files.
set directory^=~/.vim/_temp//   " where to put swap files.

""
"" Status line
""

if has("statusline") && !&cp
	set laststatus=2 " always show the status bar

	" Start the status line
	set statusline=%f\ %m\ %r\ 
	set statusline+=Line:%l/%L[%p%%]\ 
	set statusline+=Col:%v\ 
	set statusline+=Buf:#%n\ 
endif

"
"" File types
""

" Some file types should wrap their text
function! s:setupWrapping()
	set wrap
	set linebreak
	set textwidth=72
	set nolist
endfunction


filetype plugin indent on " Turn on filetype plugins (:help filetype-plugin)

if has("autocmd")
	" Make sure all mardown files have the correct filetype set and setup wrapping
	au BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn,txt} setf markdown
	au FileType markdown call s:setupWrapping()

	" Treat JSON files like JavaScript
	au BufNewFile,BufRead *.{json,jsonp} set ft=javascript
endif

""
"" CtrlP
""

let g:ctrlp_working_path_mode = 0
let g:ctrlp_reuse_window = 'netrw\|help\|quickfix'

""
"" snipmate
""

" Snippets directory
let g:snippets_dir= '~/.vim/snippets'

""
"" NERDTree
""

set autoread
let NERDTreeHijackNetrw = 0

augroup AuNERDTreeCmd
autocmd AuNERDTreeCmd VimEnter * call s:CdIfDirectory(expand("<amatch>"))

" If the parameter is a directory, cd into it
function s:CdIfDirectory(directory)
	let explicitDirectory = isdirectory(a:directory)
	let directory = explicitDirectory || empty(a:directory)

	if explicitDirectory
		exe "cd " . fnameescape(a:directory)
	endif

	" Allows reading from stdin
	" ex: git diff | mvim -R -
	if strlen(a:directory) == 0
		return
	endif

	if directory
		NERDTree
		wincmd p
		bd
	endif

	if explicitDirectory
		wincmd p
	endif
endfunction

""
"" Misc
""

" Place the cursor on its previous position in this file
function! ResCur()
	if line("'\"") <= line("$")
		normal! g`"
		return 1
	endif
endfunction

augroup resCur
	autocmd!
	autocmd BufWinEnter * call ResCur()
augroup END

""
"" Mappings
""

" Ack
map <leader>/ :Ack 
" commentary
nmap <D-/> gcc
vmap <D-/> gc
" NERDTree
nnoremap <f2> :NERDTreeToggle<cr>

" Load a local configuration
if filereadable(glob("~/.vimrc.local")) 
    source ~/.vimrc.local
endif
