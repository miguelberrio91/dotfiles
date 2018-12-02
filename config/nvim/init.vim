" init.vim

" runtime! archlinux.vim

let $CONFIG_PATH = expand('$HOME/.config/nvim')

" Plugins {{{ "
call plug#begin('$HOME/.local/share/nvim/plugged')
"--------------------------------------------------"
" UI
Plug 'mhinz/vim-startify'
" Statusline
Plug 'vim-airline/vim-airline'
" Required by airline
Plug 'Lokaltog/powerline-fonts'
Plug 'chrisbra/Colorizer'
Plug 'romainl/Apprentice',             { 'branch' : 'fancylines-and-neovim' }

" Languages
Plug 'sheerun/vim-polyglot'
Plug 'mattn/emmet-vim',                { 'for'    : [ 'html', 'xml', 'handlebars' ] }
Plug 'othree/html5.vim',               { 'for'    : 'html' }
Plug 'gregsexton/MatchTag',            { 'for'    : [ 'html', 'xml', 'handlebars' ] }

Plug 'plasticboy/vim-markdown',        { 'for'    : 'markdown' }

" Fold code in Python
Plug 'tmhedberg/SimpylFold',           { 'for'    : 'python' }
Plug 'vim-scripts/indentpython.vim',   { 'for'    : 'python' }

" Rust filetype *** TODO: CHECK OPTIONS ***
Plug 'rust-lang/rust.vim',             { 'for'    : 'rust' }
Plug 'racer-rust/vim-racer',           { 'for'    : 'rust' }
Plug 'timonv/vim-cargo',               { 'for'    : 'rust' }
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch'                                    : 'next',
    \ 'do'                                        : 'bash install.sh',
    \ }

Plug 'cespare/vim-toml',               { 'for'    : 'toml' }

Plug 'lervag/vimtex'

" Plug 'fatih/vim-go',                 { 'for'    : 'go', 'do': ':GoInstallBinaries' }

" Commenting operations
Plug 'scrooloose/nerdcommenter'
" Close quotes, parenthesis, brackets, etc automatic
Plug 'jiangmiao/auto-pairs'
" Browse tags of source files
Plug 'majutsushi/tagbar'
" Add, change and delete surroundings
Plug 'tpope/vim-surround'

" Tools
" Git integration (Show diff on files)
Plug 'airblade/vim-gitgutter'
" Git commands
Plug 'tpope/vim-fugitive',             { 'as'     : 'fugitive.vim' }
" Git commit browser
Plug 'junegunn/gv.vim'
Plug 'ervandew/supertab'
" Alignment tool
Plug 'junegunn/vim-easy-align'
" Auto indent
Plug 'godlygeek/tabular'
" Repeat last command (Also when it's a plugin-map)
Plug 'tpope/vim-repeat'
" Rename buffer and file on disk
Plug 'vim-scripts/Rename'
" Turn off caps when change from insert to normal mode
Plug 'suxpert/vimcaps'
" Easy motions
Plug 'easymotion/vim-easymotion'
" The best fuzzy finder
Plug 'junegunn/fzf.vim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

Plug 'benekastah/neomake'
" Code completion
Plug ('Shougo/deoplete.nvim'),         { 'do'     : ':UpdateRemotePlugins' }
Plug ( 'zchee/libclang-python3' ),
Plug ('zchee/deoplete-clang'),

" Plug 'zchee/deoplete-go',            { 'do'     : 'make'}
Plug 'sebastianmarkow/deoplete-rust',  { 'for'    : 'rust' }
"Plug 'nsf/gocode',                    { 'rtp'    : 'nvim', 'do': '~/.config/nvim/plugged/gocode/nvim/symlink.sh' }

" A better Vimdiff Git mergetool
Plug 'whiteinge/diffconflicts'
"--------------------------------------------------"
call plug#end()
" }}} Plugins "

" File specific config {{{ "
let g:tex_flavor = 'tex'
filetype plugin indent on
" }}} File specific config "

" Autocommands {{{ "

" Reload init.vim after any change in the config
augroup reload_vimrc
    autocmd!
    autocmd BufWritePost $MYVIMRC nested :source $MYVIMRC
    autocmd BufWritePost $HOME/.config/nvim/*.vim nested :source $MYVIMRC
    autocmd BufWritePost $MYVIMRC AirlineRefresh
augroup END

" Autoremove trailing white spaces spaces and convert tabs in spaces
autocmd BufWritePre * silent! %s/\s\+$//ge
autocmd BufWritePre * %retab!

" Show relative numbers in normal mode
autocmd InsertEnter * set nornu
autocmd InsertLeave * set rnu

" Make file executable
autocmd FileType sh,bash,perl,python,ruby nno <leader>ex :! chmod +x %<CR>
" }}} Autocommands "

" Colorscheme {{{ "
if (has("termguicolors"))
    set termguicolors
endif

syntax enable
colorscheme apprentice
" }}} Colorscheme "

" Functions {{{ "
" Highlight all instances of word under cursor, when idle.
" Useful when studying strange source code.
" Type z/ to toggle highlighting on/off.
nnoremap z/ :if AutoHighlightToggle()<Bar>set hls<Bar>endif<CR>
function! AutoHighlightToggle()
    let @/ = ''
    if exists('#auto_highlight')
        autocmd! auto_highlight
        augroup! auto_highlight
        setlocal updatetime=4000
        echo 'Highlight current word: off'
        return 0
    else
        augroup auto_highlight
            autocmd!
            autocmd CursorHold * let @/ = '\V\<'.escape(expand('<cword>'), '\').'\>'
        augroup end
        setlocal updatetime=500
        echo 'Highlight current word: ON'
        return 1
    endif
endfunction

" Open all config files
function! Open_config()
    e $MYVIMRC
    arga $CONFIG_PATH/*.vim
    arga $CONFIG_PATH/ftplugin/*.vim
endfunction

" Close all the config files
function! Close_config()
    let s:bufNr = bufnr("$")
    while s:bufNr > 0
        if buflisted(s:bufNr)
            if (matchstr(bufname(s:bufNr), "^".$CONFIG_PATH) == $CONFIG_PATH)
                if getbufvar(s:bufNr, '&modified') == 0
                    execute "bd ".s:bufNr
                endif
            endif
        endif
        let s:bufNr = s:bufNr - 1
    endwhile
endfunction

" From: https://github.com/autozimu/LanguageClient-neovim/issues/379#issuecomment-403876177
" let g:ulti_expand_res = 0 "default value, just set once
" function! CompleteSnippet()
"   if empty(v:completed_item)
"     return
"   endif
"
"   call UltiSnips#ExpandSnippet()
"   if g:ulti_expand_res > 0
"     return
"   endif
"
"   let l:complete = type(v:completed_item) == v:t_dict ? v:completed_item.word : v:completed_item
"   let l:comp_len = len(l:complete)
"
"   let l:cur_col = mode() == 'i' ? col('.') - 2 : col('.') - 1
"   let l:cur_line = getline('.')
"
"   let l:start = l:comp_len <= l:cur_col ? l:cur_line[:l:cur_col - l:comp_len] : ''
"   let l:end = l:cur_col < len(l:cur_line) ? l:cur_line[l:cur_col + 1 :] : ''
"
"   call setline('.', l:start . l:end)
"   call cursor('.', l:cur_col - l:comp_len + 2)
"
"   call UltiSnips#Anon(l:complete)
" endfunction
"
" autocmd CompleteDone * call CompleteSnippet()

" From: https://github.com/autozimu/LanguageClient-neovim/issues/379#issuecomment-394071180
function! ExpandLspSnippet()
    call UltiSnips#ExpandSnippetOrJump()
    if !pumvisible() || empty(v:completed_item)
        return ''
    endif

    " only expand Lsp if UltiSnips#ExpandSnippetOrJump not effect.
    let l:value = v:completed_item['word']
    let l:matched = len(l:value)
    if l:matched <= 0
        return ''
    endif

    " remove inserted chars before expand snippet
    if col('.') == col('$')
        let l:matched -= 1
        exec 'normal! ' . l:matched . 'Xx'
    else
        exec 'normal! ' . l:matched . 'X'
    endif

    if col('.') == col('$') - 1
        " move to $ if at the end of line.
        call cursor(line('.'), col('$'))
    endif

    " expand snippet now.
    call UltiSnips#Anon(l:value)
    return ''
endfunction

imap <C-j> <C-R>=ExpandLspSnippet()<CR>

" }}} Functions "

" Mappings {{{ "
" Escape commands
ino jk <Esc>
ino JK <Esc>
cno jk <Esc>
cno JK <Esc>
nno <C-q> <Esc>
vno <C-q> <Esc>

" Fast commands
nno <leader>w :w<CR>
nno <leader>sw :w !sudo tee %<CR>
nno <leader>so :so %<cr>
nmap <leader>pi :PlugInstall<CR>
nmap <leader>pu :PlugUpdate<CR>

" Spell
nno <leader>ss :set spell!<CR>
nno <leader>sde :set spelllang=de_de<CR>
nno <leader>sen :set spelllang=en_us<CR>
nno <leader>ses :set spelllang=es_mx<CR>

" Move through buffers
nno <silent> <leader>q :bdelete<CR>
nno <silent> <Tab> :bnext<CR>
nno <silent> <S-Tab> :bprevious<CR>

" Tabs
nno <silent> <leader>h :tabp<CR>
nno <silent> <leader>l :tabn<CR>

" Windows
no <C-j> <C-W>j
no <C-k> <C-W>k
no <C-h> <C-W>h
no <C-l> <C-W>l

no <leader>vq <C-W>q
no <leader>vl :vertical resize +10<CR>
no <leader>vh :vertical resize -10<CR>
no <leader>vj :res +10<CR>
no <leader>vk :res -10<CR>

" Moving characters
nno L xp
nno H Xph

" Move through wrapped lines
imap <silent> <Down> <C-o>gj
imap <silent> <Up> <C-o>gk
nmap <silent> <Down> gj
nmap <silent> <Up> gk

" Return to visual selection when indenting
vno < <gv
vno > >gv

" Move to next instance of the word
no <Space>j *
no <Space>k #

" Move faster through text
" nno <C-e> 5<C-e>
" nno <C-y> 5<C-y>
" vno <C-e> 5<C-e>
" vno <C-y> 5<C-y>

" Select all text
map <Space>a ggVG

" Copy until the end of the line
no Y y$

" Clean search highligt
no <silent> <leader>/ :nohlsearch<CR>
no <silent> <Space><Space> :nohlsearch<CR>

" Edit nvim config files
nmap <silent> <leader>ev :call Open_config()<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>
nmap <silent> <leader>cv :call Close_config()<CR>

" In-file navigation with enter and backspace
nnoremap <BS> {
onoremap <BS> {
vnoremap <BS> {

nnoremap <expr> <CR> empty(&buftype) ? '}' : '<CR>'
onoremap <expr> <CR> empty(&buftype) ? '}' : '<CR>'
vnoremap <CR> }

" Open search results in quickfix
nmap <silent> <leader>o :vim // %<CR>:copen<CR>
" }}} Mappings "

" Settings {{{ "
" backups, undos, swaps
set nobackup
set noswapfile

" clipboard
set clipboard+=unnamedplus

" Precision editing
set cursorcolumn
set cursorline

" encoding
set encoding=utf-8

" errorbells
set noerrorbells
set visualbell

" folding
set foldlevel=0
set foldcolumn=3
set foldnestmax=2
set nofoldenable

" indent
set breakindent
set autoindent
set smartindent

" line break
set linebreak

" performance
set lazyredraw
set ttyfast

" regex
set magic

" searching
set ignorecase
set incsearch

" sidescroll
set sidescrolloff=15
set sidescroll=1

" style of divider
autocmd ColorScheme * hi VertSplit cterm=NONE ctermbg=NONE ctermfg=green

" tabs
set laststatus=4
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4

" trails
set list
set listchars=tab:\|\ ,trail:·,precedes:«,extends:»,nbsp:·

" ui
set autoread
set hidden
set nu
set rnu
set scrolloff=5

" Updatetime
set updatetime=500

" windows
set splitbelow
set splitright

" Highlight ugly code
highlight OverLength ctermbg=red ctermfg=white guibg=#870000
" match ErrorMsg '\%81v'
let w:m2=matchadd('OverLength', '\%121v', -1)
match ErrorMsg '\s\+$'
" }}} Settings "

" ***** PLUGINS ***** {{{
" }}}

" Airline {{{ "
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#tab_min_count = 2
let g:airline#extensions#tabline#show_splits = 1
let g:airline#extensions#tabline#show_tabs = 0
let g:airline#extensions#tabline#buffers_label = 'b'
let g:airline#extensions#tabline#tabs_label = 't'
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#tabline#keymap_ignored_filetypes = ['vimfiler', 'nerdtree']
let g:airline#extensions#tabline#buffer_nr_show = 0
let g:airline#extensions#tabline#tab_nr_type = 3 " splits and tab number
let g:airline_powerline_fonts = 1
let g:Powerline_symbols = 'fancy'
let g:airline_detect_modified=1
let g:airline_detect_paste=1
let g:airline_detect_spell=1
set laststatus=2

let g:airline_mode_map = {
            \ '__' : '-',
            \ 'n'  : 'N',
            \ 'i'  : 'I',
            \ 'R'  : 'R',
            \ 'c'  : 'C',
            \ 'v'  : 'V',
            \ 'V'  : 'V',
            \ '' : 'V',
            \ 's'  : 'S',
            \ 'S'  : 'S',
            \ '' : 'S',
            \ }
" powerline symbols
let g:airline_left_alt_sep = ''
let g:airline_right_alt_sep = ''

let g:airline_theme='apprentice'
" }}} Airline "

" Autopairs {{{ "
let g:AutoPairsMapCR = 0
imap <silent><CR> <CR><Plug>AutoPairsReturn
" }}} Autopairs "

" Deoplete - Completion framework {{{ "
let g:deoplete#enable_at_startup = 1
" }}} Deoplete - Completion framework "

" Easy align {{{ "
" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
" }}} Easy align "

" Easymotion {{{ "
map <leader><leader> <Plug>(easymotion-prefix)
nmap F <Plug>(easymotion-prefix)s
" }}} Easymotion "

" Fugitive.vim - Git commands {{{ "
nmap <leader>gs :Gstatus<CR>
nmap <leader>gd :Gdiff<CR>
nmap <leader>gc :Gcommit<CR>
nmap <leader>gb :Gblame<CR>
" }}} Fugitive.vim - Git commands "

" FZF - Fuzzy finder {{{ "
no <C-Space> :FZF<CR>
no <C-\> :Buffers<CR>
nno ? :GFiles<CR>

" This is the default extra key bindings
let g:fzf_action = {
            \ 'ctrl-t': 'tab split',
            \ 'ctrl-x': 'split',
            \ 'ctrl-v': 'vsplit' }

" Default fzf layout
" - down / up / left / right
let g:fzf_layout = { 'down': '~40%' }

" In Neovim, you can set up fzf window using a Vim command
let g:fzf_layout = { 'window': 'enew' }
let g:fzf_layout = { 'window': '-tabnew' }

" Customize fzf colors to match your color scheme
let g:fzf_colors =
            \ { 'fg':    ['fg', 'Normal'],
            \ 'bg':      ['bg', 'Normal'],
            \ 'hl':      ['fg', 'Comment'],
            \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
            \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
            \ 'hl+':     ['fg', 'Statement'],
            \ 'info':    ['fg', 'PreProc'],
            \ 'prompt':  ['fg', 'Conditional'],
            \ 'pointer': ['fg', 'Exception'],
            \ 'marker':  ['fg', 'Keyword'],
            \ 'spinner': ['fg', 'Label'],
            \ 'header':  ['fg', 'Comment'] }
" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1

" [[B]Commits] Customize the options used by 'git log':
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

" [Tags] Command to generate tags file
let g:fzf_tags_command = 'ctags -R'

function! s:fzf_statusline()
    " Override statusline as you like
    highlight fzf1 ctermfg=161 ctermbg=251
    highlight fzf2 ctermfg=23 ctermbg=251
    highlight fzf3 ctermfg=237 ctermbg=251
    setlocal statusline=%#fzf1#\ >\ %#fzf2#fz%#fzf3#f
endfunction

autocmd! User FzfStatusLine call <SID>fzf_statusline()
" }}} FZF - Fuzzy finder "

" Gitgutter {{{ "
nno ]h :GitGutterNextHunk<CR>
nno [h :GitGutterPrevHunk<CR>
nnoremap <Leader>hr :GitGutterRevertHunk<CR>
nnoremap <Leader>ha :GitGutterStageHunk<CR>
nnoremap <Leader>hh :GitGutterLineHighlightsToggle<CR>
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '~'
let g:gitgutter_sign_removed = '-'
let g:gitgutter_sign_modified_removed = '~'
let g:gitgutter_grep_command = 'rg'
" }}} Gitgutter "

" Language Client {{{ "
set hidden
let g:LanguageClient_autoStart = 1
let g:LanguageClient_serverCommands = {
    \ 'rust'           : ['rustup', 'run', 'stable', 'rls'],
    \ 'javascript'     : ['/usr/local/bin/javascript-typescript-stdio'],
    \ 'javascript.jsx' : ['tcp://127.0.0.1:2089'],
    \ 'python'         : ['/usr/local/bin/pyls'],
    \ }

nnoremap <F5> :call LanguageClient_contextMenu()<CR>
nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>
" }}} Language Client "

" Neomake {{{ "
let g:neomake_open_list = 2
call neomake#configure#automake('rw', 1000)
" }}} Neomake "

" NERD Commenter {{{ "
nmap <Space>c <leader>c<Space>
vmap <Space>c <leader>c<Space>

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1
" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'
" Set a language to use its alternate delimiters by default
let g:NERDAltDelims_java = 1
" Add your own custom formats or override the defaults
let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }
let g:NERDCustomDelimiters = { 'handlebars': { 'left': '<!--','right': '-->' } }
let g:NERDCustomDelimiters = { 'hbs': { 'left': '<!--','right': '-->' } }
" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1
" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1
" }}} NERD Commenter "

" Python provider for Neovim {{{ "
let g:python_host_prog  = '/usr/bin/python2'
let g:python3_host_prog = '/usr/bin/python3'
" }}} Python provider for Neovim "

" SimplyFold {{{ "
let g:SimpylFold_docstring_preview=1
" }}} SimplyFold "

" Startify {{{ "
autocmd User Startified setlocal cursorline

let g:startify_files_number = 8

let g:startify_change_to_dir = 1
let g:startify_change_to_vcs_root = 1
let g:startify_relative_path = 1

let g:ctrlp_reuse_window = 'startify'
let g:startify_fortune_use_unicode = 1

let g:startify_session_dir = '~/.local/share/nvim/sessions'
let g:startify_session_persistence = 1
let g:startify_session_delete_buffers = 1
let g:startify_session_sort = 1

let g:startify_custom_indices = map(range(1,100), 'string(v:val)')

let g:startify_lists = [
            \ { 'type' : 'sessions'  , 'header' : ['   Sessions']       } ,
            \ { 'type' : 'files'     , 'header' : ['   MRU']            } ,
            \ { 'type' : 'bookmarks' , 'header' : ['   Bookmarks']      } ,
            \ { 'type' : 'commands'  , 'header' : ['   Commands']       } ,
            \ ]

let g:startify_bookmarks = [
            \ '$HOME/.dotfiles/.make_scripts/make_install_packages',
            \ { 'p' : '$HOME/.config/polybar/config' },
            \ { 't' : '$HOME/.tmux.conf' },
            \ { 'x' : '$HOME/.config/i3/config' },
            \ { 'z' : '$HOME/.zshrc' },
            \ ]

let g:startify_commands = [
            \ { 'n' : ['Open Nvim config files', 'call Open_config()'] },
            \ ]

let g:startify_skiplist = [
            \ '^/tmp',
            \ ]

hi StartifyHeader  ctermfg=114
" }}} Startify "

" Supertab {{{ "
let g:SuperTabDefaultCompletionType = "<c-n>"
" let g:SuperTabDefaultCompletionType = "<c-x><c-u>"
" }}} Supertab "

" Tagbar {{{ "
nmap <F8> :TagbarToggle<CR>
let g:tagbar_autoshowtag = 1
" }}} Tagbar "

" Ultisnips {{{ "
let g:UltiSnipsExpandTrigger = "<Tab>"
let g:UltiSnipsJumpForwardTrigger="<Tab>"
let g:UltiSnipsJumpBackwardTrigger="<S-Tab>"
let g:UltiSnipsListSnippets = "<c-q>"

let g:UltiSnipsEditSplit="vertical"

set runtimepath+=~/.local/share/nvim
let g:UltiSnipsSnippetDirectories = ['snippets/UltiSnips', 'UltiSnips']
" }}} Ultisnips "

" vim-plug {{{ "
let g:plug_window = 'enew'
" }}} vim-plug "

" Vim-polyglot {{{ "
let g:polyglot_disabled = ['latex']
" }}} Vim-polyglot "
"
" Vimtex {{{ "
" let g:vimtex_latexmk_options = '-pdf -verbose -bibtex -file-line-error -synctex=1 --interaction=nonstopmode'
let g:vimtex_compiler_latexmk = {
            \ 'build_dir' : 'build',
            \}

let g:vimtex_view_method = 'zathura'

if !exists('g:deoplete#omni#input_patterns')
    let g:deoplete#omni#input_patterns = {}
endif
let g:deoplete#omni#input_patterns.tex = g:vimtex#re#deoplete
" }}} Vimtex "
