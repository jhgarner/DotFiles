# Setup fzf
# ---------
if [[ ! "$PATH" == */home/jack/.fzf/bin* ]]; then
  export PATH="$PATH:/home/jack/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/jack/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/home/jack/.fzf/shell/key-bindings.zsh"

