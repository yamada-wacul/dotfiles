HIGHLIGHTING='/usr/share/zsh-syntax-highlighting'
if [ -d "${HIGHLIGHTING}/highlighters" ]; then
    export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR="${HIGHLIGHTING}/highlighters"
    for f in $(find "${HIGHLIGHTING}/highlighters" -name "*.zsh"); do
        if [ ! -e "${f}.zwc" ] || [ "${f}" -nt "${f}.zwc" ]; then
            zcompile "${f}" >/dev/null 2>&1 || :
        fi
    done
    _source_if "${HIGHLIGHTING}/zsh-syntax-highlighting.zsh"
fi
