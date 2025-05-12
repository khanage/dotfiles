export XDG_CACHE_HOME=$HOME/.cache
export XDG_CONFIG_HOME=$HOME/.config

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source <(fzf --zsh)

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git kubectl history brew docker macos nvm rust zsh-autosuggestions zsh-syntax-highlighting web-search zsh-vi-mode fzf-tab) 

ZSH=${ZSH:="$HOME/.oh-my-zsh"}

source $ZSH/oh-my-zsh.sh

alias ls='lsd -A'
alias exa='exa --icons'
alias vim=nvim
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias top=btm

export ZSH="$HOME/.oh-my-zsh"
export PATH=$HOME/.cargo/bin:$HOME/.ghcup/bin:/opt/homebrew/opt/python/libexec/bin/:/opt/homebrew/opt/curl/bin:$HOME/.local/bin:$HOME/.dotnet/tools:/usr/local/go/bin:/opt/homebrew/opt/ruby/bin:$PATH
export BAT_PAGER=""
export BAT_THEME="Catppuccin-mocha"
export RIPGREP_CONFIG_PATH=$HOME/.ripgreprc
export EDITOR=vim
export FZF_DEFAULT_COMMAND="fd --type f --color=always --exclude .git --ignore-file ~/.gitignore"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

