
function transfer() {
    : ${1?"usage: ${FUNCNAME[0]} <file or dir> [<file or dir...."}
    echo "(base64 -d || base64 -D) <<EOT | gzip -cd | tar xvf -"
    tar cf - "$@" | gzip -c9 | base64
    echo "EOT"
}

export PAGER=less
export LESS='-SifMRF'
export LESSCHARSET=UTF-8

export PATH=$PATH:~/bin:~/go/bin:/usr/local/go/bin

alias egrep='egrep --color=auto'
alias grep='grep --color=auto'
alias ls='ls --color=auto -FA'

export SSH_AUTH_SOCK=/run/user/$(id -u)/gnupg/S.gpg-agent.ssh
