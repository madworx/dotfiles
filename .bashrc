
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
export LESS='-Si'
export LESSCHARSET=UTF-8

alias egrep='egrep --color=auto'
alias grep='grep --color=auto'
alias ls='ls --color=auto -FA'
