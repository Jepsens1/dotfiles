eval "$(starship init zsh)"
export PATH=$PATH:$HOME/go/bin
export EDITOR="nvim"
export SUDO_EDITOR="$EDITOR"

HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=50000

alias ls='ls -l --color=auto'
alias grep='grep --color=auto'

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
