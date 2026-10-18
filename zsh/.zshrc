eval "$(starship init zsh)"
export EDITOR="nvim"
export SUDO_EDITOR="$EDITOR"

HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=50000

alias ls='ls -l --color=auto'
alias ll='ls -la --color=auto'
alias grep='grep --color=auto'
alias lzg='lazygit'

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

eval "$($HOME/.local/bin/mise activate zsh --shims)" # added by https://mise.run/zsh

# opencode
export PATH=$HOME/.opencode/bin:$PATH
