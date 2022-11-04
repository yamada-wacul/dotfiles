# 自動補完の設定
if [ -d /usr/local/share/zsh-completions ]; then
    fpath=(/usr/local/share/zsh-completions $fpath)
fi
plugins=(zsh-completions zsh-syntax-highlighting $plugins)
autoload -Uz compinit && compinit
