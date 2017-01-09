setopt hist_ignore_all_dups inc_append_history
HISTFILE=~/.zhistory

HISTSIZE=4096000
SAVEHIST=4096000

export ERL_AFLAGS="-kernel shell_history enabled"
