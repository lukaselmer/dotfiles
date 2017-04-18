# load custom executable functions
for function in ~/.zsh/functions/*; do
  source $function
done

# modify the prompt to contain git branch name if applicable
git_prompt_info() {
  current_branch=$(git current-branch 2> /dev/null)
  if [[ -n $current_branch ]]; then
    echo " %{$fg_bold[green]%}$current_branch%{$reset_color%}"
  fi
}
setopt promptsubst
export PS1='${SSH_CONNECTION+"%{$fg_bold[green]%}%n@%m:"}%{$fg_bold[blue]%}%c%{$reset_color%}$(git_prompt_info) %# '

# auto completion will be handled by oh my zsh
# load our own completion functions
# fpath=(~/.zsh/completion /usr/local/share/zsh/site-functions $fpath)
# completion
# autoload -U compinit
# compinit will be executed by oh my zsh


# makes color constants available
autoload -U colors
colors

# enable colored output from ls, etc
export CLICOLOR=1

# history settings
setopt hist_ignore_all_dups inc_append_history
HISTFILE=~/.zhistory
HISTSIZE=100000
SAVEHIST=100000

# awesome cd movements from zshkit
setopt autocd autopushd pushdminus pushdsilent pushdtohome cdablevars
DIRSTACKSIZE=5

# Enable extended globbing
setopt extendedglob

# Allow [ or ] whereever you want
unsetopt nomatch

# vi mode
bindkey -v
bindkey "^F" vi-cmd-mode
bindkey jj vi-cmd-mode

# handy keybindings
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey "^K" kill-line
bindkey "^R" history-incremental-search-backward
bindkey "^P" history-search-backward
bindkey "^Y" accept-and-hold
bindkey "^N" insert-last-word
bindkey -s "^T" "^[Isudo ^[A" # "t" for "toughguy"

# aliases
[[ -f ~/.aliases ]] && source ~/.aliases


# extra files in ~/.zsh/configs/pre , ~/.zsh/configs , and ~/.zsh/configs/post
# these are loaded first, second, and third, respectively.
_load_settings() {
  _dir="$1"
  if [ -d "$_dir" ]; then
    if [ -d "$_dir/pre" ]; then
      for config in "$_dir"/pre/**/*~*.zwc(N-.); do
        . $config
      done
    fi

    for config in "$_dir"/**/*(N-.); do
      case "$config" in
        "$_dir"/(pre|post)/*|*.zwc)
          :
          ;;
        *)
          . $config
          ;;
      esac
    done

    if [ -d "$_dir/post" ]; then
      for config in "$_dir"/post/**/*~*.zwc(N-.); do
        . $config
      done
    fi
  fi
}
_load_settings "$HOME/.zsh/configs"

# oh my zsh
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="robbyrussell"
HIST_STAMPS="yyyy-mm-dd"
# currently disabled, leads to error: github
# currently disabled, very slow: nvm
# would be nice: plugins=(github nvm git git-flow nvm lol npm nyan osx screen coffee dircycle encode64 bundler brew gem rails svn rake cp git-extras heroku python autojump)
plugins=(git git-flow lol npm nyan osx screen coffee dircycle encode64 bundler gem rails svn rake cp git-extras heroku python autojump)
# measure time: echo "init" && { time (
source $ZSH/oh-my-zsh.sh
# ) } && echo "init done"
#
# load custom executable functions
# for function in ~/.zsh/functions/*; do
#   source $function
# done
PROMPT=' ${ret_status}%{$fg_bold[green]%}%p %{$fg[cyan]%}%c %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%} % %{$reset_color%}'
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY
# general
export ARCHFLAGS="-arch x86_64"
export MANPATH="/usr/local/man:$MANPATH"
export CHROME_BIN="$HOME/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
export FIREFOX_BIN="$HOME/Applications/Firefox.app/Contents/MacOS/firefox-bin"
export PGDATA=/usr/local/var/postgres
export LC_CTYPE=en_US.UTF-8
export LANGUAGE="en_US.UTF-8"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export EDITOR=vim
export VISUAL=vim
export GIT_EDITOR=vim
export BLAS=/usr/local/opt/openblas/lib/libopenblas.a
export LAPACK=/usr/local/opt/openblas/lib/libopenblas.a
export PYENV_ROOT="$HOME/.pyenv"
# general path adjustments
export PATH="$HOME/.bin:$PATH"
export PATH="/usr/local/bin:$PATH"
export PATH="$HOME/.scripts:$PATH"
export PATH="$PYENV_ROOT/bin:$PATH"
export PATH="$HOME/.rbenv/bin:$PATH"
export PATH="$PATH:/usr/local/opt/coreutils/libexec/gnubin"
# python / pyenv
eval "$(pyenv init - zsh)"
eval "$(pyenv virtualenv-init -)"
source ~/.pyenv/completions/pyenv.zsh
# ruby / rbenv
eval "$(rbenv init - zsh --no-rehash)"
# npm / nvm
source ~/.nvm/nvm.sh
autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"
  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")
    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

# fuck
eval "$(thefuck --alias)"

# aws
[[ -f ~/.aws/export_cred.sh ]] && source ~/.aws/export_cred.sh
source /usr/local/share/zsh/site-functions/_aws

# Local config
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# aliases
[[ -f ~/.aliases ]] && source ~/.aliases

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
