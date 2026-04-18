typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
autoload -Uz compinit
compinit -d ~/.cache/zsh/zcompdump

path=(
$HOME/.local/bin
$HOME/bin
$path
)
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.cache/zsh

ZSH_PLUGIN_DIR="$HOME/.config/zsh/plugins"

source $ZSH_PLUGIN_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh
source $ZSH_PLUGIN_DIR/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

export NVM_DIR="$HOME/.nvm"
nvm() {
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  command nvm "$@"
}
source ~/.config/zsh/zinit/zinit.zsh

zinit light zdharma-continuum/fast-syntax-highlighting
zinit light romkatv/powerlevel10k
zinit light zdharma-continuum/history-search-multi-word
zinit light zsh-users/zsh-history-substring-search


[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
[ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh

autoload -Uz compinit
compinit -d ~/.cache/zsh/zcompdump

ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#777"
# -------------------------------------------------
# Aliases
# -------------------------------------------------
alias nv='nvim'
alias cl='clear'
alias py='python'
alias sc='source'
alias bt='rofi-bluetooth'
alias i='yay -S'
alias s='yay -Ss'
alias ls='eza --icons --group-directories-first'
alias ll='eza -lah --icons --group-directories-first'
alias tree='eza --tree'
alias cat='bat'
alias grep='grep --color=auto'
alias mkdir='mkdir -pv'
alias nf='clear && nitch'
alias reload='source ~/.config/zsh/.zshrc'

HISTSIZE=10000
SAVEHIST=10000

setopt appendhistory
setopt sharehistory
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_reduce_blanks

# -------------------------------------------------
# zoxide
# -------------------------------------------------
eval "$(zoxide init zsh)"

# -------------------------------------------------
# Powerlevel10k prompt config
# -------------------------------------------------
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# -------------------------------------------------
# Spicetify
# -------------------------------------------------
export PATH=$PATH:/home/rotmayer24/.spicetify

# -------------------------------------------------
# Custom environment scripts
# -------------------------------------------------
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

[ -e /home/rotmayer24/.nix-profile/etc/profile.d/nix.sh ] && . /home/rotmayer24/.nix-profile/etc/profile.d/nix.sh
