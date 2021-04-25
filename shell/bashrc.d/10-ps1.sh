esc-rgb() {
    echo -e "\[\033[38;2;${1};${2};${3}m\]"
}
esc-rgb-bold() {
    echo -e "\[\033[1;38;2;${1};${2};${3}m\]"
}
esc-clear() {
    echo -e "\[\033[0m\]"
}

# PS1 setup

ps-username() {
    echo "$(esc-rgb-bold 128 192 255)\u$(esc-clear)"
}

ps-hostname() {
    echo "$(esc-rgb 128 160 192)@\h$(esc-clear)"
}

ps-working-dir() {
    echo "$(esc-rgb 192 192 192)\W$(esc-clear)"
}

ps-prompt() {
    echo "$(esc-rgb 128 128 128)\$$(esc-clear)"
}

PS1="$(ps-username)$(ps-hostname) $(ps-working-dir) $(ps-prompt) "
