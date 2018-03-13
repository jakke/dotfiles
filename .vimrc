" enable extension recognition and syntax highlighting
set nocompatible              " be iMproved, required
" key bindings
let mapleader = ","

let starting_directory = getcwd()
filetype off                  " required
let g:netrw_dirhistmax = 0
" set shell=/bin/bash

set runtimepath+=/<homedir>/.vim
" set the runtime path to include Vundle and initialize
"also add local user path for local extensions
"set rtp+=~/.vim/bundle/vundle
set runtimepath+=/<homedir>/.vim/bundle/Vundle.vim/
" call vundle#begin('/<homedir>/.vim/bundle/')
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/nerdcommenter'
Plugin 'altercation/vim-colors-solarized'
Plugin 'jlanzarotta/bufexplorer'
Plugin 'ervandew/supertab'
Plugin 'majutsushi/tagbar'
Plugin 'craigemery/vim-autotag'
" Plugin 'buztard/vim-nomad'
Plugin 'b4b4r07/vim-hcl'
Plugin 'thecodesmith/vim-groovy'
Plugin 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'} "status line to show branch info eg
"Plugin 'Valloric/YouCompleteMe' "autocompleter
Plugin 'kien/ctrlp.vim' "super searcher
Plugin 'tpope/vim-fugitive' "git integration
Plugin 'hashivim/vim-hashicorp-tools' "hashicorp tools for vim
Plugin 'fatih/vim-hclfmt'
call vundle#end()

"some tricks for NERDTree bugs
" NERDTree setting defaults to work around
" http://github.com/scrooloose/nerdtree/issues/489
let g:NERDTreeDirArrows = 1
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
let g:NERDTreeGlyphReadOnly = "RO"
let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree

augroup myvimrc
    autocmd!
    autocmd QuickFixCmdPost [^l]* cwindow
    autocmd QuickFixCmdPost l*    lwindow
augroup END

"python with virtualenv support
py << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
  project_base_dir = os.environ['VIRTUAL_ENV']
  activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
  execfile(activate_this, dict(__file__=activate_this))
EOF


set clipboard=unnamed

filetype on 
filetype plugin on 
syntax enable

set autoindent
set noerrorbells visualbell t_vb=
" omit the /g option in search and replace, since that will undo the global replace!!
set gdefault
" enable line numbering
set number
"set mouse=a

" color theme settings: dark bg + 256 terminal colors
set background=dark
set t_Co=256
colors nightVisionICTS
set incsearch
set hlsearch
set shortmess=atI

" ignore
set wildignore=*.swp,*.bak,*.pyc,*.class,*.pyc,*.pyo
let g:netrw_list_hide= '.*\.pyc$,.*\.pyo$,*\.swp$,tags'

set nocp

fun! MakeAndKeepOutput()
    make
    cw
    redraw!
endfun

fun! FindTags()
"        silent !clear
"        let tagfile = system("/nasfs/groups/fii/bin/upsearch.sh tags ". shellescape(starting_directory))
"starting directory is global, so prefix g: is required
        let tagfile = findfile("tags", g:starting_directory.";")
"        let &tags += tagfile
        execute "set tags+=".tagfile
"        silent !clear
"        redraw!
endfun

fun! VimFind(pattern,location)
    execute "vimgrep /".a:pattern."/j ".a:location
endfunction

" !command -nargs=* CustomGrep call VimFind(<f-args>) <CR>
nmap <leader>g :CustomGrep

au BufRead,BufNewFile *.pp set filetype=puppet
let g:syntastic_auto_loc_list = 1 

if !exists("autocommands_loaded")
    let autocommands_loaded = 1
    " file types
    autocmd FileType javascript set ts=4 sw=4
    autocmd FileType html set ts=2 sw=2
    autocmd BufNewFile,BufRead *.css.dtml setfiletype css
    autocmd FileType css set ts=2 sw=2
    autocmd BufNewFile,BufRead *.zcml setfiletype xml

    " zcml
    autocmd FileType xml set ts=2 sw=2

    " python
    autocmd FileType python set ts=4 sw=4
    autocmd FileType python set makeprg=pymake\ %
    autocmd FileType python set efm=%f:%l:%m
    autocmd FileType python set textwidth=120
    autocmd FileType python match Error /\%>79v.\+/
    autocmd FileType python call FindTags()
    autocmd BufNewFile,BufRead *.cpy,*.vpy set filetype python
    autocmd BufWritePost,FileWritePost *.py,*.cpy,*.vpy :call MakeAndKeepOutput()

endif

" last step of expanding tabs to spaces
set smarttab
set expandtab 
set laststatus=4
set ts=4 sw=4

" syntax to enable python tab completion
"set ofu=syntaxcomplete#Complete
"let g:pydiction_location = '/home/dev/.vim/pydiction-1.2/complete-dict'


"color schemes
map <leader>l :set background=light<CR>
map <leader>d :set background=dark<CR>

"dev tools
map <F12> <Leader>be
map <F5> :NERDTreeToggle<CR>
" extra nerdcommenter option, introduces space after comment character
let NERDSpaceDelims=1

"working with ctags
nmap <F8> :TagbarToggle<CR>
map <F9> :call FindTags()<CR>
"map <F9> :set tags=tags;<CR>
"map default <Ctrl>-] to a list of matches, if only 1, that one is selected
"otherwise a choice has to be made
noremap <c-]> g<c-]>

"python fancyness
nmap <Leader>p oimport pdb; pdb.set_trace()<ESC>
nmap \q :%s/\'/\"/<CR>

" change commenter plugin
map <leader>c <Plug>NERDComInvertComment
vmap <leader>c <Plug>NERDComInvertComment

"always show statusline with filename
set laststatus=2
set statusline=%F%M%R\ [TYPE=%Y]\ [FORMAT=%{&ff}]

"do autochdir later on, to avoid it being done too early for other plugins
set autochdir

" enable vimrc editing with 2 key
map <F11> :e ~/.vimrc<CR>
" When vimrc is edited, reload it
autocmd! bufwritepost .vimrc source ~/.vimrc
