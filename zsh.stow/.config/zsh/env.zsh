# Local Env Var
export EDITOR=nvim
export BROWSER=/usr/bin/chromium
export GIT_EDITOR=nvim
export VISUAL=nvim
export LESSCHARSET=UTF-8
# export TERM=tmux-256color

# Add Scripts to Path
export PATH=$PATH:$HOME/Scripts
export PATH=$PATH:$HOME/bin
# Add Screenlayouts to path
export PATH=$PATH:$HOME/.screenlayout
# Cargo env
export PATH=$PATH:$HOME/.cargo/bin
export RUST_SRC_PATH=~/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src
# IntelliJ Idea env
export PATH=$PATH:/opt/idea-IC-171.4694.23/bin
# Local binary path
export PATH=$PATH:$HOME/.local/bin
# Go env
# export PATH=$PATH:$(go env GOPATH)/bin
# export GOPATH=$(go env GOPATH)

export LS_COLORS=$LS_COLORS:'ow=01;34;40'

# To add completion for rustup, run
# $ rustup completions zsh > ~/.local/share/zsh/functions/Completion/_rustup
fpath=( "$HOME/.local/share/zsh/functions/Completion" $fpath )

# -------------------- FZF FuzzyFinder -------------------- #

export FZF_DEFAULT_COMMAND='fdfind --hidden --follow --type file --exclude .git --exclude .wine'
export FZF_TMUX=1
# export FZF_TMUX_HEIGHT=30\%
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fdfind --follow --type directory'
export FZF_ALT_C_OPTS="--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"
