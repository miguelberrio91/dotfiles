# reload zsh config
alias zsh!='RELOAD=1 source ~/.zshrc'

# Editor
alias vim='nvim'
alias vi='nvim'
alias edit='nvim'

# ls commands
alias ls='ls -A --color=auto --group-directories-first'
alias ll='ls -l --color=auto --group-directories-first'
alias la='ls -lA --color=auto --group-directories-first'
alias l='ls -Ax --color=auto --group-directories-first'
alias lh='ls -lh --color=auto --group-directories-first'

# Ranger
alias r='ranger'
alias ranger='ranger --choosedir=$HOME/.config/ranger/rangedir;cd $(cat $HOME/.config/ranger/rangedir)'

# Open file
function o() {
    for i in "$@"
        do
        xdg-open "$i" > /dev/null 2>&1 &
    done
    i3 scratchpad show > /dev/null 2>&1
}

# cd aliases

alias tmp='cd $(mktemp -d)'

alias ..='cd ../'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'

# git aliases

alias gs="git status"

alias git-undopush="git push -f origin HEAD^:master"
alias cpbr="git rev-parse --abbrev-ref HEAD | pbcopy"

alias git-prune='git remote prune origin && git fetch -p && git branch -vv | awk '"'"'/: gone]/{print $1}'"'"' | xargs git branch -D'

function give-credit() {
    git commit --amend --author $1 <$2> -C HEAD
}

# a simple git rename file function
# git does not track case-sensitive changes to a filename.
function git-rename() {
    git mv $1 "${2}-"
    git mv "${2}-" $2
}

unalias g
function g() {
    if [[ $# > 0 ]]; then
        # if there are arguments, send them to git
        git $@
    else
        # otherwise, run git status
        git status
    fi
}

# fd in WSL
alias fd=fdfind

# dotnet
alias dotnet=dotnet.exe
alias nuget=nuget.exe

alias psh='powershell.exe /c'

function vs() {
    local vs='/mnt/c/Program Files (x86)/Microsoft Visual Studio/2019/Professional/Common7/IDE/devenv.exe'
    if [[ $# > 0 ]]; then
        command "$vs" $1 &
    else
        command "$vs" &
    fi
}
