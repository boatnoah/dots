# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# global npm packages
export PATH=~/.npm-global/bin:$PATH

# export editor
export EDITOR=nvim




# Set update frequency
zstyle ':omz:update' frequency 13

# Rofi scripts
export PATH=$HOME/.config/rofi/scripts:$PATH

# Plugins
plugins=(git zsh-syntax-highlighting zsh-autosuggestions)



# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region
bindkey -s '^f' '^u~/scripts/fzf-tmux.sh^M'

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"


# Source Oh-My-Zsh
source $ZSH/oh-my-zsh.sh

# Bash like time format
disable -r time       # disable shell reserved word
alias time='time -p ' # -p for POSIX output


# User configuration
#
alias nvconf='nvim ~/.config/nvim/init.lua'
alias zshrc='nvim ~/.zshrc'
alias c='clear'
alias h='~'
alias ff='fastfetch'

# Oh My Posh initialization
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/zen.toml)"

# NVM lazy loading
export NVM_DIR="$HOME/.nvm"
lazy_load_nvm() {
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}
nvm() {
  unset -f nvm
  lazy_load_nvm
  nvm "$@"
}


alias dot='/usr/bin/git --git-dir=/home/boat/.dots/ --work-tree=/home/boat'
PATH="$HOME/.local/bin:$PATH"


function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}
