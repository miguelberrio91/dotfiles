" init.vim

" runtime! archlinux.vim

let $CONFIG_PATH = expand('$HOME/.config/nvim')

let $NVIM_PLUG_SOURCE = expand('$HOME/.local/share/nvim/site/autoload/plug.vim')
let $NVIM_PLUG_DIR = expand('$HOME/.local/share/nvim/plugged')
let $NVIM_SESSIONS_DIR = expand('$HOME/.local/share/nvim/sessions')

if empty(glob($NVIM_PLUG_SOURCE))
  silent !curl -fLo $NVIM_PLUG_SOURCE --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Pluggins {{{ "
call plug#begin($NVIM_PLUG_DIR)

" Aesthetics
Plug 'romainl/Apprentice',         { 'branch' : 'fancylines-and-neovim' }
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'

" TODO: Activate???
" Plug 'mhinz/vim-startify'
" Save persistent sessions on a workspace
Plug 'thaerkh/vim-workspace'

" Language Client
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch'                    : 'next',
    \ 'do'                    : 'bash install.sh',
    \ }

" Rust plugins
Plug 'rust-lang/rust.vim'
Plug 'racer-rust/vim-racer'
Plug 'cespare/vim-toml'

" Add, change and delete surroundings
Plug 'tpope/vim-surround'

" Git integration (Show diff on files)
Plug 'airblade/vim-gitgutter'
Plug 'itchyny/vim-gitbranch'

" A better Vimdiff Git mergetool
" Plug 'whiteinge/diffconflicts'

" Easy motions
Plug 'easymotion/vim-easymotion'

" Commentaries
Plug 'tpope/vim-commentary'

" Close quotes, parenthesis, brackets, etc automatic
Plug 'jiangmiao/auto-pairs'

"Alignment tool
Plug 'godlygeek/tabular'

" Fuzzy finder
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all'  }
Plug 'junegunn/fzf.vim'

" Snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" Neomake
Plug 'benekastah/neomake'

" Code completion
Plug ('Shougo/deoplete.nvim'),         { 'do'     : ':UpdateRemotePlugins' }
Plug 'sebastianmarkow/deoplete-rust'

" Toggle quickfix with \q and location list with \l
Plug 'milkypostman/vim-togglelist'

call plug#end()
" }}} Pluggins "

" Autopairs {{{ "
let g:AutoPairsFlyMode = 1
let g:AutoPairsShortcutBackInsert = '<M-b>'
" let g:AutoPairs['<']='>'
let g:AutoPairsMapCR = 0
imap <silent><CR> <CR><Plug>AutoPairsReturn
" }}} Autopairs "

" Deoplete - Completion framework {{{ "
let g:deoplete#enable_at_startup = 1
" }}} Deoplete - Completion framework "

" Easymotion {{{ "
map <leader><leader> <Plug>(easymotion-prefix)
nmap F <Plug>(easymotion-prefix)s
" }}} Easymotion "

" FZF - Fuzzy finder {{{ "
no <Leader>ff :FZF<CR>
no <Leader>fb :Buffers<CR>
no <Leader>fg :GFiles<CR>
" }}} FZF - Fuzzy finder "

" Gitgutter {{{ "
let g:gitgutter_map_keys = 0
nmap ]h <Plug>GitGutterNextHunk
nmap [h <Plug>GitGutterPrevHunk

nmap <Leader>hp <Plug>GitGutterPreviewHunk
nmap <Leader>hs <Plug>GitGutterStageHunk
nmap <Leader>hu <Plug>GitGutterUndoHunk
nmap <Leader>hh :GitGutterLineHighlightsToggle<CR>

" Use hunks as objects
omap ih <Plug>GitGutterTextObjectInnerPending
omap ah <Plug>GitGutterTextObjectOuterPending
xmap ih <Plug>GitGutterTextObjectInnerVisual
xmap ah <Plug>GitGutterTextObjectOuterVisual

let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '~'
let g:gitgutter_sign_removed = '-'
let g:gitgutter_sign_modified_removed = '~_'
let g:gitgutter_grep_command = 'rg'
" }}} Gitgutter "

" Language Client {{{ "
let g:LanguageClient_autoStart = 1
let g:LanguageClient_serverCommands = {
    \ 'rust'           : ['rustup', 'run', 'stable', 'rls'],
    \ }

function! LC_maps()
    if has_key(g:LanguageClient_serverCommands, &filetype)
        nnoremap <F5> :call LanguageClient_contextMenu()<CR>
        nnoremap <buffer> <silent> K :call LanguageClient#textDocument_hover()<cr>
        nnoremap <buffer> <silent> gd :call LanguageClient#textDocument_definition()<CR>
        nnoremap <buffer> <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
    endif
endfunction
autocmd FileType * call LC_maps()
" }}} Language Client "

" Lightline {{{ "
let g:lightline = {}
let g:lightline.colorscheme = 'apprentice'

let g:lightline.component_function = { 'gitbranch' : 'GitBranchName' }
let g:lightline.active = {
            \ 'left' : [ [ 'mode', 'paste' ],
            \            [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
            \ }

function! GitBranchName()
    let b:name = gitbranch#name()
    if b:name != '' && GitGutterGetHunks() != []
        return b:name . "*"
    endif
    return b:name
endfunction

let g:lightline#bufferline#show_number  = 1
let g:lightline.tabline          = {'left': [['buffers']], 'right': [[]]}
let g:lightline.component_expand = {'buffers': 'lightline#bufferline#buffers'}
let g:lightline.component_type   = {'buffers': 'tabsel'}
" }}} Lightline "

" Neomake {{{ "
let g:neomake_open_list = 0
call neomake#configure#automake('rw', 1000)
" }}} Neomake "

" Python provider for Neovim {{{ "
let g:python_host_prog  = '/usr/bin/python2'
let g:python3_host_prog = '/usr/bin/python3'
" }}} Python provider for Neovim "

" Ultisnips {{{ "
let g:UltiSnipsExpandTrigger = "<C-j>"
let g:UltiSnipsJumpForwardTrigger="<C-j>"
let g:UltiSnipsJumpBackwardTrigger="<C-k>"
let g:UltiSnipsListSnippets = "<c-q>"

let g:UltiSnipsEditSplit="vertical"

set runtimepath+=~/.config/nvim
let g:UltiSnipsSnippetDirectories = ['snippets/UltiSnips', 'UltiSnips']
let g:UltiSnipsSnippetDir = "~/.config/nvim/snippets/UltiSnips"
" }}} Ultisnips "

" Workspace {{{ "
nnoremap <leader>s :ToggleWorkspace<CR>
let g:workspace_session_directory = $NVIM_SESSIONS_DIR
let g:workspace_persist_undo_history = 0
let g:workspace_autosave = 0
let g:workspace_session_disable_on_args = 1
" }}} Workspace "
