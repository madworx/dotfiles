
function transfer() {
    : ${1?"usage: ${FUNCNAME[0]} <file or dir> [<file or dir...."}
    echo "(base64 -d || base64 -D) <<EOT | gzip -cd | tar xvf -"
    tar cf - "$@" | gzip -c9 | base64
    echo "EOT"
}

function brightness() {
    : ${1?"Usage: ${FUNCNAME[0]} <0-255>"}
    sudo sh -c "echo $1 > /sys/class/backlight/amdgpu_bl0/brightness"
}

export PAGER=less
export LESS='-SifMRF'
export LESSCHARSET=UTF-8

export PATH=$PATH:~/bin:~/go/bin:/usr/local/go/bin

alias egrep='egrep --color=auto'
alias grep='grep --color=auto'
alias ls='ls --color=auto -FA'
alias bat='upower -i /org/freedesktop/UPower/devices/battery_BAT0'
alias rekey='gpg-connect-agent "scd serialno" "learn --force" /bye'
alias top='top -H -1'

export SSH_AUTH_SOCK=/run/user/$(id -u)/gnupg/S.gpg-agent.ssh
