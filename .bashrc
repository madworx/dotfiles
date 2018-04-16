
#
# 
#
function transfer() {
    : ${1?"usage: ${FUNCNAME[0]} <file or dir> [<file or dir...."}
    echo "base64 -d <<EOT | gzip -cd | tar xvf -"
    tar cf - $* | gzip -c9 | base64
    echo "EOT"
}

export PAGER=less
export LESS='-SifM'
export LESSCHARSET=UTF-8
export GIT_PAGER=cat

export PATH=$PATH:~/bin

alias egrep='egrep --color=auto'
alias grep='grep --color=auto'
alias ls='ls --color=auto -FA'
