eval "$(/opt/homebrew/bin/brew shellenv)"
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# theme powerlevel10k
source /opt/homebrew/opt/powerlevel10k/powerlevel10k.zsh-theme

# completion
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
fi
FPATH=$HOME/.zsh-completions:$FPATH
autoload -Uz compinit && compinit -i

# aliases
alias ls='ls -GF'
alias l='ls'
alias ll='l -l'
alias la='l -a'
alias lla='l -la'
alias g=git
alias o=open
alias t=tmux

# env
export CLICOLOR=1

# Typo correction
setopt CORRECT

# history
SAVEHIST=10000
HISTSIZE=10000
setopt APPEND_HISTORY ## Addition of the history file
setopt HIST_IGNORE_ALL_DUPS ## Ignore all repetitions of commands
setopt HIST_FIND_NO_DUPS ## Do not display the string found earlier
setopt HIST_IGNORE_DUPS ## Ignore rows if they are duplicates
setopt HIST_REDUCE_BLANKS ## Delete empty lines from history file
setopt HIST_IGNORE_SPACE ## Ignore a record starting with a space
setopt HIST_NO_STORE ## Do not add history and fc commands to the history
setopt SHARE_HISTORY # Share history between session/terminals

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# yarn
if which yarn 1>/dev/null 2>&1; then
  export PATH="$(yarn global bin):$PATH"
fi

# prioritize my bin dir
export PATH="$HOME/bin:$PATH"

# load local config
[[ ! -f ~/.zsh.local ]] || source ~/.zsh.local
