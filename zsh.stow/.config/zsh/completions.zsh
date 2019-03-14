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
    source /usr/share/fzf/completion.zsh
    source /usr/share/fzf/key-bindings.zsh
else
    echo Please install fzf
fi

