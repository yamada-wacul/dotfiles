# asdf-vm
asdf_initilizes=("/opt/asdf-vm/asdf.sh" "/usr/local/opt/asdf/libexec/asdf.sh" "${HOME}/.asdf/asdf.sh")
for asdf_init in $asdf_initilizes; do
    if [ -f "$asdf_init" ]; then
        . "$asdf_init"
    fi
done

# direnv
if command -v direnv >/dev/null 2>&1; then
    eval "$(command direnv hook zsh)"
fi

# Lua
if command -v luarocks >/dev/null 2>&1; then
    eval "$(luarocks --lua-version=5.4 path)"
fi
