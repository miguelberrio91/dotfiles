# reload zsh config
alias zsh!='RELOAD=1 source "$HOME/.zshrc"'

# dotdrop {{{ #
dot() { $DOTREPO/dotdrop/dotdrop.sh --cfg=$DOTREPO/config-home.yaml --profile={{@@ profile @@}} $@ }
sdot() { sudo -E $DOTREPO/dotdrop/dotdrop.sh --cfg=$DOTREPO/config-root.yaml --profile={{@@ profile @@}} $@ }
# }}} dotdrop #

#  Editor {{{ #
alias vim='nvim'
alias vi='nvim'
alias edit='nvim'
#  }}} Editor #

#  ls aliases {{{ #
alias ls='exa --color=auto --group-directories-first'
alias l='exa -a --color=auto --group-directories-first'
alias ll='exa -l --git --color=auto --group-directories-first'
alias la='exa -la --git --color=auto --group-directories-first'
alias lt='exa -lT --git-ignore --git --color=auto --group-directories-first'
#  }}} ls aliases #

#  Open file {{{ #
function o() {
    for i in "$@"
        do
        xdg-open "$i" > /dev/null 2>&1 &
    done
    i3 scratchpad show > /dev/null 2>&1
}
#  }}} Open file #

#  cd aliases {{{ #
alias tmp='cd $(mktemp -d)'

alias ..='cd ../'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'
#  }}} cd aliases #

#  Git aliases {{{ #
alias gs='git status'

# A simple git rename file function
# git does not track case-sensitive changes to a filename.
function gmv() {
    git mv $1 "${2}-"
    git mv "${2}-" $2
}

alias gprune='git remote prune origin && git fetch -p && git branch -vv | awk '"'"'/: gone]/{print $1}'"'"' | xargs git branch -D'
#  }}} Git aliases #

# mbsync {{{ #
alias mbsync="mbsync -c \"$XDG_CONFIG_HOME/isync/mbsyncrc\""
# }}} mbsync #

#  tmux aliases {{{ #
alias ta='tmux attach'
alias tls='tmux ls'
alias tat='tmux attach -t'
alias tns='tmux new-session -s'
alias dev='. ~/bin/tmux-dev'
alias rdev='. ~/bin/tmux-rdev'
#  }}} tmux aliases #

# Vimwiki {{{ #
alias diary='nvim +VimwikiMakeDiaryNote +Goyo'
alias idea='nvim ~/vimwiki/Scratchpad.md +Goyo'
alias todo='nvim ~/vimwiki/Todo.md +Goyo'
alias vimwiki='nvim +VimwikiIndex'
alias zettel='nvim ~/vimwiki/Tags.md'
# }}} Vimwiki #

# vim: foldmethod=marker
