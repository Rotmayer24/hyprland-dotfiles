typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source ~/.config/zsh/zinit/zinit.zsh

zinit light romkatv/powerlevel10k
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zdharma-continuum/history-search-multi-word
zinit light zsh-users/zsh-history-substring-search
zinit light zsh-users/zsh-autosuggestions

path=(
  $HOME/.local/bin
  $HOME/bin
  $HOME/.spicetify
  $path
)

HISTFILE="$HOME/.local/share/zsh/history"
HISTSIZE=20000
SAVEHIST=20000

setopt append_history
setopt share_history
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_verify
setopt extended_history

autoload -Uz compinit
zmodload zsh/complist

if [[ -n ${ZDOTDIR:-$HOME}/.cache/zsh/zcompdump(#qN.mh+24) ]]; then
  compinit -d ~/.cache/zsh/zcompdump
else
  compinit -C -d ~/.cache/zsh/zcompdump
fi

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.cache/zsh
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

setopt auto_cd
setopt no_beep
setopt interactive_comments

ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#777"
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
[ -f /usr/share/fzf/completion.zsh ]   && source /usr/share/fzf/completion.zsh

export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"

export NVM_DIR="$HOME/.nvm"
nvm() {
  unfunction nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh" --no-use
  [ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
  nvm "$@"
}
node() { nvm use default --silent; node "$@" }
npm()  { nvm use default --silent; npm  "$@" }
npx()  { nvm use default --silent; npx  "$@" }

eval "$(zoxide init zsh)" 2>/dev/null

[ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ] && \
  source "$HOME/.nix-profile/etc/profile.d/nix.sh" 2>/dev/null

[ -f "$HOME/.local/bin/env" ] && source "$HOME/.local/bin/env" 2>/dev/null

alias ls='eza --icons --group-directories-first'
alias ll='eza -lah --icons --group-directories-first'
alias tree='eza --tree --icons'
alias mkdir='mkdir -pv'

alias nv='nvim'
alias cl='clear'
alias py='python'
alias cat='bat --paging=never'
alias grep='grep --color=auto'
alias nf='clear && nitch'
alias reload='source ${ZDOTDIR:-$HOME/.config/zsh}/.zshrc'

alias i='yay -S'
alias r='yay -R'
alias s='yay -Ss'
alias u='yay -Syu'

alias network='sudo systemctl start NetworkManager'
alias bt='rofi-bluetooth'
alias ur='uv run'

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
