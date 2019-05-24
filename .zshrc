# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory autocd extendedglob nomatch notify correctall hist_ignore_all_dups hist_ignore_space prompt_subst
unsetopt beep
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/jack/.zshrc'

autoload -Uz compinit
compinit
export KEYTIMEOUT=1
# End of lines added by compinstall

zstyle ':completion:*' rehash true
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*:approximate:' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3 )) numeric)'
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'


autoload -Uz promptinit
promptinit
source /home/jack/.async.zsh
source /home/jack/.pure.zsh
# prompt pure

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

zstyle ':completion:*:descriptions' format '%U%B%d%b%u' 

export VISUAL=kak
export EDITOR="$VISUAL"
export OFFICE=libreoffice
export PDFVIEWER="zathura --fork"
export VIDEOVIEWER=mpv
export WINE=wine


export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
path+=('/home/jack/.stack/compiler-tools/x86_64-linux-tinfo6/ghc-8.4.4/bin')
path+=('/home/jack/.stack/compiler-tools/x86_64-linux-tinfo6/ghc-8.6.3/bin')
path+=('/home/jack/.local/bin')
path+=('/home/jack/code/ruby/autograder/bin')

alias -s cpp=$EDITOR
alias -s doc=$OFFICE
alias -s docx=$OFFICE
alias -s exe=$WINE
alias -s h=$EDITOR
alias -s md=$EDITOR
alias -s mp4=$VIDEOVIEWER
alias -s mkv=$VIDEOVIEWER
alias -s ods=$OFFICE
alias -s odt=$OFFICE
alias -s pdf=$PDFVIEWER
alias -s ppt=$OFFICE
alias -s pptx=$OFFICE
alias -s tex=$EDITOR
alias -s txt=$EDITOR
alias -s xls=$OFFICE
alias -s xlsx=$OFFICE

# Up arrow search
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down
bindkey -M vicmd "k" up-line-or-beginning-search
bindkey -M vicmd "j" down-line-or-beginning-search
bindkey "^?" backward-delete-char


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
