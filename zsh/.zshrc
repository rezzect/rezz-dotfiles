# Bring "xterm" up to "xterm-256color", fairly well expected this should work
[[ "$TERM" == "xterm" ]] && export TERM="xterm-256color"
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
eval "$(oh-my-posh init zsh)"
# make sure antigen exists
if [[ ! -a ~/.antigen.zsh ]]; then
  wget https://git.io/antigen -O ~/.antigen.zsh
fi

# Add .local/bin
if [[ ! "$PATH" =~ "$HOME/.local/bin" ]]; then
  export PATH="$HOME/.local/bin:$PATH"
fi

# load in antigen
source ~/.antigen.zsh

# plugins from oh-my-zsh
antigen bundle git

# plugins from other repos
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting

# finish up
antigen apply

# zsh autosuggestions
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# Preferred Editor
export EDITOR="nano"

eval "$(oh-my-posh init zsh --config ~/.omp-themes/rezztheme-edit.omp.json)"
eval "$(zoxide init zsh)"

# Default Aliases
alias omp-update='curl -s https://ohmyposh.dev/install.sh | sudo bash -s' #Update Oh-My-Posh

# Call on .alias file
. ~/.aliases

