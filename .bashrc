#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias v='nvim'
alias gs='git status'
PS1='[\u@\h \W]\$ '

eval "$(zoxide init bash)"

# https://yazi-rs.github.io/docs/quick-start/
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# https://junegunn.github.io/fzf/shell-integration/
eval "$(fzf --bash)"
