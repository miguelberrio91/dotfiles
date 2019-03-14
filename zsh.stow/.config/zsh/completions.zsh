# Create directory $HOME/.local/share/zsh/functions/Completion
if [[ ! -d $HOME/.local/share/zsh/functions/Completion ]]; then
    mkdir -p $HOME/.local/share/zsh/functions/Completion
fi

fpath=( "$HOME/.local/share/zsh/functions/Completion" $fpath )

# Rustup completion
#if (( $+commands[rustup] )); then
#    if [[ ! -a $HOME/.local/share/zsh/functions/Completion/_rustup ]]; then
#        rustup completions zsh > $HOME/.local/share/zsh/functions/Completion/_rustup
#    fi
#else
#    echo Please install rustup
#fi

# FZF completion
if (( $+commands[fzf] )); then
    source $HOME/.fzf/shell/completion.zsh
    source $HOME/.fzf/shell/key-bindings.zsh
else
    echo Please install fzf
fi

