alias dd='dd status=progress'
alias ls='ls --color=auto'
alias cal='cal --color=auto'
alias grep='grep --color=auto'
alias imcat='img2sixel'

get() {
    curl -XGET -s -H 'Content-Type: application/json' -H 'Accepts: application/json' "$@" | jq
}

post() {
    curl -XPOST -s -H 'Content-Type: application/json' -H 'Accepts: application/json' --data-binary @- "$@" | jq
}

spawn() {
    footclient -N 2>/dev/null & disown
}
